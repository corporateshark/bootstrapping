#!/usr/bin/env python

# Dependencies (not needed at the moment; commented out below)
# > pip install progressbar
# > pip install paramiko
# > pip install scp

from __future__ import print_function
import platform
import os
import sys
import shutil
import subprocess
import zipfile
import tarfile
import hashlib
import json
import getopt
#import progressbar

try:
    from urllib.request import urlparse
    from urllib.request import urlunparse
    from urllib.request import urlretrieve
    from urllib.request import quote
except ImportError:
    from urlparse import urlparse
    from urlparse import urlunparse
    from urllib import urlretrieve
    from urllib import quote

try:
    import paramiko
    import scp
    scp_available = True
except:
    scp_available = False
    print("WARNING: Please install the Python packages [paramiko, scp] for full script operation.")

SRC_DIR_BASE = "src"
ARCHIVE_DIR_BASE = "archives"
SNAPSHOT_DIR_BASE = "snapshots"

BASE_DIR = os.getcwd()
SRC_DIR = os.path.join(BASE_DIR, SRC_DIR_BASE)
ARCHIVE_DIR = os.path.join(BASE_DIR, ARCHIVE_DIR_BASE)
SNAPSHOT_DIR = os.path.join(BASE_DIR, SNAPSHOT_DIR_BASE)

DEFAULT_PNUM = 3
DEBUG_OUTPUT = False
FALLBACK_URL = ""

USE_TAR = False
USE_UNZIP = False

if platform.system() == "Windows":
    os.environ['CYGWIN'] = "nodosfilewarning"

def log(string):
    print("--- " + string)

def dlog(string):
    if DEBUG_OUTPUT:
        print("*** " + string)

def executeCommand(command, printCommand = False, quiet = False):

    printCommand = printCommand or DEBUG_OUTPUT
    out = None
    err = None

    if quiet:
        out = open(os.devnull, 'w')
        err = subprocess.STDOUT

    if printCommand:
        if DEBUG_OUTPUT:
            dlog(">>> " + command)
        else:
            log(">>> " + command)

    return subprocess.call(command, shell = True, stdout=out, stderr=err);


def dieIfNonZero(res):
    if res != 0:
        raise ValueError("Command returned non-zero status.");


def cloneRepository(type, url, target_name, revision = None, try_only_local_operations = False):
    target_dir = os.path.join(SRC_DIR, target_name)
    target_dir_exists = os.path.exists(target_dir)
    log("Cloning " + url + " to " + target_dir)

    if type == "hg":
        repo_exists = os.path.exists(os.path.join(target_dir, ".hg"))

        if not repo_exists:
            if try_only_local_operations:
                raise RuntimeError("Repository for " + target_name + " not found; cannot execute local operations only")
            if target_dir_exists:
                dlog("Removing directory " + target_dir + " before cloning")
                shutil.rmtree(target_dir)
            dieIfNonZero(executeCommand("hg clone " + url + " " + target_dir))
        elif not try_only_local_operations:
            log("Repository " + target_dir + " already exists; pulling instead of cloning")
            dieIfNonZero(executeCommand("hg pull -R " + target_dir))

        if revision is None:
            revision = ""
        dieIfNonZero(executeCommand("hg update -R " + target_dir + " -C " + revision))
        dieIfNonZero(executeCommand("hg purge -R " + target_dir + " --config extensions.purge="))

    elif type == "git":
        repo_exists = os.path.exists(os.path.join(target_dir, ".git"))

        if not repo_exists:
            if try_only_local_operations:
                raise RuntimeError("Repository for " + target_name + " not found; cannot execute local operations only")
            if target_dir_exists:
                dlog("Removing directory " + target_dir + " before cloning")
                shutil.rmtree(target_dir)
            dieIfNonZero(executeCommand("git clone " + url + " " + target_dir))
        elif not try_only_local_operations:
            log("Repository " + target_dir + " already exists; fetching instead of cloning")
            dieIfNonZero(executeCommand("git -C " + target_dir + " fetch"))

        if revision is None:
            revision = "HEAD"
        dieIfNonZero(executeCommand("git -C " + target_dir + " reset --hard " + revision))
        dieIfNonZero(executeCommand("git -C " + target_dir + " clean -fxd"))

    elif type == "svn":
        if not try_only_local_operations: # we can't do much without a server connection when dealing with SVN
            if target_dir_exists:
                dlog("Removing directory " + target_dir + " before cloning")
                shutil.rmtree(target_dir)
            dieIfNonZero(executeCommand("svn checkout " + url + " " + target_dir))

        if revision is not None and revision != "":
            raise RuntimeError("Updating to revision not implemented for SVN.")

    else:
        raise ValueError("Cloning " + type + " repositories not implemented.")


def extractFile(filename, target_dir):
    if os.path.exists(target_dir):
        # log("Target directory " + filename + " already exists; removing directory...")
        shutil.rmtree(target_dir)

    log("Extracting file " + filename)
    stem, extension = os.path.splitext(os.path.basename(filename))

    if extension == ".zip":
        zfile = zipfile.ZipFile(filename)
        extract_dir = os.path.commonprefix(zfile.namelist())
        extract_dir_local = ""
        if extract_dir == "":  # deal with stupid zip files that don't contain a base directory
            extract_dir, extension2 = os.path.splitext(os.path.basename(filename))
            extract_dir_local = extract_dir
        extract_dir_abs = os.path.join(SRC_DIR, extract_dir_local)

        try:
            os.mkdirs(extract_dir_abs)
        except:
            pass

        if not USE_UNZIP:
            zfile.extractall(extract_dir_abs)
            zfile.close()
        else:
            zfile.close()
            dieIfNonZero(executeCommand("unzip " + filename + " -d " + extract_dir_abs))

    elif extension == ".tar" or extension == ".gz" or extension == ".bz2":
        tfile = tarfile.open(filename)
        extract_dir = os.path.commonprefix(tfile.getnames())
        extract_dir_local = ""
        if extract_dir == "":  # deal with stupid tar files that don't contain a base directory
            extract_dir, extension2 = os.path.splitext(os.path.basename(filename))
            extract_dir_local = extract_dir
        extract_dir_abs = os.path.join(SRC_DIR, extract_dir_local)

        try:
            os.mkdirs(extract_dir_abs)
        except:
            pass

        if not USE_TAR:
            tfile.extractall(extract_dir_abs)
            tfile.close()
        else:
            tfile.close()
            dieIfNonZero(executeCommand("tar -x -f " + filename + " -C " + extract_dir_abs))

    else:
        raise RuntimeError("Unknown compressed file format " + extension)

    if platform.system() == "Windows":
        extract_dir = extract_dir.replace( '/', '\\' )
        target_dir = target_dir.replace( '/', '\\' )
        if extract_dir[-1::] == '\\':
            extract_dir = extract_dir[:-1]

    # rename extracted folder to target_dir
    extract_dir_abs = os.path.join(SRC_DIR, extract_dir)
    os.rename(extract_dir_abs, target_dir)


def createArchiveFromDirectory(src_dir_name, archive_name, delete_existing_archive = False):
    if delete_existing_archive and os.path.exists(archive_name):
        dlog("Removing snapshot file " + archive_name + " before creating new one")
        os.remove(archive_name)

    archive_dir = os.path.dirname(archive_name)
    if not os.path.isdir(archive_dir):
        os.mkdir(archive_dir)

    with tarfile.open(archive_name, "w:gz") as tar:
        tar.add(src_dir_name, arcname = os.path.basename(src_dir_name))


def downloadSCP(hostname, username, path, target_dir):
    if not scp_available:
        log("ERROR: missing Python packages [paramiko, scp]; cannot continue.")
        raise RuntimeError("Missing Python packages [paramiko, scp]; cannot continue.")
    ssh = paramiko.SSHClient()
    ssh.load_system_host_keys()
    ssh.connect(hostname = hostname, username = username)
    scpc = scp.SCPClient(ssh.get_transport())
    scpc.get(path, local_path = target_dir);


# def downloadProgress(count, block_size, total_size):
#     global pbar
#     if count == 0:
#         pbar = progressbar.ProgressBar(maxval = total_size / block_size)
#     else:
#         pbar.update(count - 1)


def computeFileHash(filename):
    blocksize = 65536
    hasher = hashlib.sha1()
    with open(filename, 'rb') as afile:
        buf = afile.read(blocksize)
        while len(buf) > 0:
            hasher.update(buf)
            buf = afile.read(blocksize)
    return hasher.hexdigest()


def downloadAndExtractFile(url, download_dir, target_dir_name, sha1_hash = None, force_download = False):
    if not os.path.isdir(download_dir):
        os.mkdir(download_dir)

    p = urlparse(url)
    url = urlunparse([p[0], p[1], quote(p[2]), p[3], p[4], p[5]]) # replace special characters in the URL path

    filename_rel = os.path.split(p.path)[1] # get original filename
    target_filename = os.path.join(download_dir, filename_rel)

    # check SHA1 hash, if file already exists
    if os.path.exists(target_filename) and sha1_hash is not None and sha1_hash != "":
        hash_file = computeFileHash(target_filename)
        if hash_file != sha1_hash:
            log("Hash of " + target_filename + " (" + hash_file + ") does not match expected hash (" + sha1_hash + "); forcing download")
            force_download = True

    # download file
    if (not os.path.exists(target_filename)) or force_download:
        log("Downloading " + url + " to " + target_filename)
        if p.scheme == "ssh":
            downloadSCP(p.hostname, p.username, p.path, download_dir)
        else:
            urlretrieve(url, target_filename)
    else:
        log("Skipping download of " + url + "; already downloaded")

    # check SHA1 hash
    if sha1_hash is not None and sha1_hash != "":
        hash_file = computeFileHash(target_filename)
        if hash_file != sha1_hash:
            raise RuntimeError("Hash of " + target_filename + " (" + hash_file + ") differs from expected hash (" + sha1_hash + ")")

    extractFile(target_filename, os.path.join(SRC_DIR, target_dir_name))


def applyPatchFile(patch_name, dir_name, pnum):
    # we're assuming the patch was applied like in this example:
    # diff --exclude=".git" --exclude=".hg" -rupN ./src/AGAST/ ./src/AGAST_patched/ > ./patches/agast.patch
    # where the first given location is the unpatched directory, and the second location is the patched directory.
    log("Applying patch to " + dir_name)
    patch_dir = os.path.join(BASE_DIR, "patches")
    arguments = "-d " + os.path.join(SRC_DIR, dir_name) + " -p" + str(pnum) + " < " + os.path.join(patch_dir, patch_name)
    argumentsBinary = "-d " + os.path.join(SRC_DIR, dir_name) + " -p" + str(pnum) + " --binary < " + os.path.join(patch_dir, patch_name)
    patch_command = "patch"
    res = executeCommand(patch_command + " --dry-run " + arguments, quiet = True)
    if res != 0:
        arguments = argumentsBinary
        res = executeCommand(patch_command + " --dry-run " + arguments, quiet = True)
    if res != 0:
        log("ERROR: patch application failure; has this patch already been applied?")
        executeCommand(patch_command + " --dry-run " + arguments, printCommand = True)
        exit(255)
    else:
        dieIfNonZero(executeCommand(patch_command + " " + arguments, quiet = True))

def runScript(script_name):
    log("Running script " + script_name)
    patch_dir = os.path.join(BASE_DIR, "patches")
    filename = os.path.join(patch_dir, script_name)
    if platform.system() == "Windows":
       dieIfNonZero(executeCommand("python " + filename, False));
    else:
       dieIfNonZero(executeCommand(filename, False));


def checkPrerequisites(*args):
    if platform.system() == "Windows":
        return 0

    for arg in args:
        if (executeCommand("which " + arg, quiet = True) != 0):
            log("ERROR: " + arg + " not found")
            return -1
    return 0


def readJSONData(filename):
    try:
        json_data = open(filename).read()
    except:
        log("ERROR: Could not read JSON file " + filename)
        return None

    try:
        data = json.loads(json_data)
    except:
        log("ERROR: Could not parse JSON document")
        return None

    return data


def writeJSONData(data, filename):
    with open(filename, 'w') as outfile:
        json.dump(data, outfile)


def listLibraries(data):
    for library in data:
        name = library.get('name', None)
        if name is not None:
            print(name)


def printOptions():
        print("Downloads external libraries, and applies patches or scripts if necessary.")
        print("If the --name argument is not provided, all available libraries will be downloaded.")
        print("Options:")
        print("  --list, -l        List all available libraries")
        print("  --name, -n        Specifies the name of a single library to be downloaded")
        print("  --clean, -c       Remove directory before obtaining library")
        print("  --base-dir, -b    Base directory, if script is called from outside of its directory")
        print("  --bootstrap-file  Specify the file containing the bootstrap JSON data")
        print("                    (default: bootstrap.json)")
        print("  --use-tar         Use 'tar' command instead of Python standard library to extract")
        print("                    tar archives")
        print("  --use-unzip       Use 'unzip' command instead of Python standard library to extract")
        print("                    zip archives")
        print("  --repo-snapshots  Create a snapshot archive of a repository when its state changes,")
        print("                    e.g. on a fallback location")
        print("  --fallback-url    Fallback URL that points to an existing and bootstrapped `external`")
        print("                    repository that may be used to retrieve otherwise unobtainable")
        print("                    archives or repositories. The --repo-snapshots option must be active")
        print("                    on the fallback server. Allowed URL schemes are file://, ssh://,")
        print("                    http://, https://, ftp://.")
        print("  --debug-output    Enables extra debugging output")

def main(argv):
    global BASE_DIR, SRC_DIR, ARCHIVE_DIR, DEBUG_OUTPUT, FALLBACK_URL, USE_TAR, USE_UNZIP

    required_commands = ["git", "hg", "svn", "patch"]
    if (checkPrerequisites(*required_commands) != 0):
        log("The bootstrapping script requires that the following programs are installed: " + ", ".join(required_commands))
        return -1

    try:
        opts, args = getopt.getopt(argv,"ln:cb:h",["list", "name=", "clean", "base-dir", "bootstrap-file=", "use-tar", "use-unzip", "repo-snapshots", "fallback-url=", "debug-output", "help"])
    except getopt.GetoptError:
        printOptions()
        return 0

    opt_names = []
    opt_clean = False
    list_libraries = False

    default_bootstrap_filename = "bootstrap.json"
    bootstrap_filename = os.path.abspath(os.path.join(BASE_DIR, default_bootstrap_filename))
    create_repo_snapshots = False

    for opt, arg in opts:
        if opt in ("-h", "--help"):
            printOptions()
            return 0
        if opt in ("-l", "--list"):
            list_libraries = True
        if opt in ("-n", "--name"):
            opt_names.append(arg)
        if opt in ("-c", "--clean"):
            opt_clean = True
        if opt in ("-b", "--base-dir"):
            ABS_PATH = os.path.abspath(arg)
            os.chdir(ABS_PATH)
            BASE_DIR = ABS_PATH
            SRC_DIR = os.path.join(BASE_DIR, SRC_DIR_BASE)
            ARCHIVE_DIR = os.path.join(BASE_DIR, ARCHIVE_DIR_BASE)
            bootstrap_filename = os.path.join(BASE_DIR, default_bootstrap_filename)
            log("Using " + arg + " as base directory")
        if opt in ("--bootstrap-file",):
            bootstrap_filename = os.path.abspath(arg)
        if opt in ("--use-tar",):
            USE_TAR = True
        if opt in ("--use-unzip",):
            USE_UNZIP = True
        if opt in ("--repo-snapshots",):
            create_repo_snapshots = True
            log("Will create repository snapshots")
        if opt in ("--fallback-url",):
            FALLBACK_URL = arg
        if opt in ("--debug-output",):
            DEBUG_OUTPUT = True

    state_filename = os.path.join(os.path.dirname(os.path.splitext(bootstrap_filename)[0]), \
                                  "." + os.path.basename(os.path.splitext(bootstrap_filename)[0])) \
                     + os.path.splitext(bootstrap_filename)[1]

    dlog("bootstrap_filename = " + bootstrap_filename)
    dlog("state_filename     = " + state_filename)

    data = readJSONData(bootstrap_filename)
    if data is None:
        return -1;

    if list_libraries:
        listLibraries(data)
        return 0

    sdata = []
    if os.path.exists(state_filename):
        sdata = readJSONData(state_filename)

    # create source directory
    if not os.path.isdir(SRC_DIR):
        log("Creating directory " + SRC_DIR)
        os.mkdir(SRC_DIR)

    # create archive files directory
    if not os.path.isdir(ARCHIVE_DIR):
        log("Creating directory " + ARCHIVE_DIR)
        os.mkdir(ARCHIVE_DIR)

    # some sanity checking
    for library in data:
        if library.get('name', None) is None:
            log("ERROR: Invalid schema: library object does not have a 'name'")
            return -1

    failed_libraries = []

    for library in data:
        name = library.get('name', None)
        source = library.get('source', None)
        post = library.get('postprocess', None)

        if (opt_names) and (not name in opt_names):
            continue

        lib_dir = os.path.join(SRC_DIR, name)

        dlog("********** LIBRARY " + name + " **********")
        dlog("lib_dir = " + lib_dir + ")")

        # compare against cached state
        cached_state_ok = False
        if not opt_clean:
            for slibrary in sdata:
                sname = slibrary.get('name', None)
                if sname is not None and sname == name and slibrary == library and os.path.exists(lib_dir):
                    cached_state_ok = True
                    break

        if cached_state_ok:
            log("Cached state for " + name + " equals expected state; skipping library")
            continue
        else:
            # remove cached state for library
            sdata[:] = [s for s in sdata if not (lambda s, name : s.get('name', None) is not None and s['name'] == name)(s, name)]

        # create library directory, if necessary
        if opt_clean:
            log("Cleaning directory for " + name)
            if os.path.exists(lib_dir):
                shutil.rmtree(lib_dir)
        if not os.path.exists(lib_dir):
            os.mkdir(lib_dir)

        try:
            # download source
            if source is not None:
                if 'type' not in source:
                    log("ERROR: Invalid schema for " + name + ": 'source' object must have a 'type'")
                    return -1
                if 'url' not in source:
                    log("ERROR: Invalid schema for " + name + ": 'source' object must have a 'url'")
                    return -1
                src_type = source['type']
                src_url = source['url']

                if src_type == "archive":
                    sha1 = source.get('sha1', None)
                    try:
                        downloadAndExtractFile(src_url, ARCHIVE_DIR, name, sha1)
                    except:
                        if FALLBACK_URL:
                            log("WARNING: Downloading of file " + src_url + " failed; trying fallback")
                            p = urlparse(src_url)
                            filename_rel = os.path.split(p.path)[1] # get original filename
                            p = urlparse(FALLBACK_URL)
                            fallback_src_url = urlunparse([p[0], p[1], p[2] + "/" + ARCHIVE_DIR_BASE + "/" + filename_rel, p[3], p[4], p[5]])
                            downloadAndExtractFile(fallback_src_url, ARCHIVE_DIR, name, sha1)
                        else:
                            raise

                else:
                    revision = source.get('revision', None)

                    archive_name = name + ".tar.gz" # for reading or writing of snapshot archives
                    if revision is not None:
                        archive_name = name + "_" + revision + ".tar.gz"

                    try:
                        cloneRepository(src_type, src_url, name, revision)

                        if create_repo_snapshots:
                            log("Creating snapshot of library repository " + name)
                            repo_dir = os.path.join(SRC_DIR, name)
                            archive_filename = os.path.join(SNAPSHOT_DIR, archive_name)

                            dlog("Snapshot will be saved as " + archive_filename)
                            createArchiveFromDirectory(repo_dir, archive_filename, revision is None)

                    except:
                        if FALLBACK_URL:
                            log("WARNING: Cloning of repository " + src_url + " failed; trying fallback")

                            # copy archived snapshot from fallback location
                            p = urlparse(FALLBACK_URL)
                            fallback_src_url = urlunparse([p[0], p[1], p[2] + "/" + SNAPSHOT_DIR_BASE + "/" + archive_name, p[3], p[4], p[5]])
                            dlog("Looking for snapshot " + fallback_src_url + " of library repository " + name)

                            # create snapshots files directory
                            downloadAndExtractFile(fallback_src_url, SNAPSHOT_DIR, name, force_download = True)

                            # reset repository state to particular revision (only using local operations inside the function)
                            cloneRepository(src_type, src_url, name, revision, True)
                        else:
                            raise
            else:
                # set up clean directory for potential patch application
                shutil.rmtree(lib_dir)
                os.mkdir(lib_dir)

            # post-processing
            if post is not None:
                if 'type' not in post:
                    log("ERROR: Invalid schema for " + name + ": 'postprocess' object must have a 'type'")
                    return -1
                if 'file' not in post:
                    log("ERROR: Invalid schema for " + name + ": 'postprocess' object must have a 'file'")
                    return -1
                post_type = post['type']
                post_file = post['file']

                if post_type == "patch":
                    applyPatchFile(post_file, name, post.get('pnum', DEFAULT_PNUM))
                elif post_type == "script":
                    runScript(post_file)
                else:
                    log("ERROR: Unknown post-processing type '" + post_type + "' for " + name)
                    return -1

            # add to cached state
            sdata.append(library)

            # write out cached state
            writeJSONData(sdata, state_filename)
        except:
            log("ERROR: Failure to bootstrap library " + name)
            failed_libraries.append(name)

    if failed_libraries:
        log("***************************************")
        log("FAILURE to bootstrap the following libraries:")
        log(', '.join(failed_libraries))
        log("***************************************")
        return -1

    log("Finished")

    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
