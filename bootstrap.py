#!/usr/bin/env python

# Dependencies (not needed at the moment; commented out below)
# > pip install progressbar
# > pip install paramiko
# > pip install scp

from __future__ import print_function

import os
import sys
import shutil
import subprocess
import urllib
import zipfile
import tarfile
import hashlib
import json
try:
    from urllib.parse import urlparse
except ImportError:
    from urlparse import urlparse

#import progressbar
#import paramiko
#import scp

BASE_DIR = os.getcwd()
SRC_DIR = os.path.join(BASE_DIR, "src")
ORIG_DIR = os.path.join(BASE_DIR, "orig")

BOOTSTRAP_FILENAME = "bootstrap.json"

def log(string):
    print("--- " + string)


def executeCommand(command, printCommand = False, quiet = False):

    out = None
    err = None

    if quiet:
        out = open(os.devnull, 'w')
        err = subprocess.STDOUT

    if printCommand:
        log(">>> " + command)

    return subprocess.call(command, shell = True, stdout=out, stderr=err);


def dieIfNonZero(res):
    if res != 0:
        raise ValueError("Command returned non-zero status.");


def cloneRepository(type, url, target_name, revision = None):
    target_dir = os.path.join(SRC_DIR, target_name)
    log("Cloning " + url + " to " + target_dir)

    if type == "hg":
        repo_exists = os.path.exists(os.path.join(target_dir, ".hg"))

        if not repo_exists:
            dieIfNonZero(executeCommand("hg clone " + url + " " + target_dir))
        else:
            log("Repository " + target_dir + " already exists; pulling instead of cloning")
            dieIfNonZero(executeCommand("hg pull -R " + target_dir))

        if revision is None:
            revision = ""
        dieIfNonZero(executeCommand("hg update -R " + target_dir + " -C " + revision))
        dieIfNonZero(executeCommand("hg purge -R " + target_dir + " --config extensions.purge="))

    elif type == "git":
        repo_exists = os.path.exists(os.path.join(target_dir, ".git"))

        if not repo_exists:
            dieIfNonZero(executeCommand("git clone " + url + " " + target_dir))
        else:
            log("Repository " + target_dir + " already exists; fetching instead of cloning")
            dieIfNonZero(executeCommand("git -C " + target_dir + " fetch"))

        if revision is None:
            revision = "HEAD"
        dieIfNonZero(executeCommand("git -C " + target_dir + " reset --hard " + revision))
        dieIfNonZero(executeCommand("git -C " + target_dir + " clean -fd"))

    elif type == "svn":
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
        zfile.extractall(os.path.join(SRC_DIR, extract_dir_local))
        zfile.close()
    elif extension == ".tar" or extension == ".gz" or extension == ".bz2":
        tfile = tarfile.open(filename)
        extract_dir = os.path.commonprefix(tfile.getnames())
        extract_dir_local = ""
        if extract_dir == "":  # deal with stupid tar files that don't contain a base directory
            extract_dir, extension2 = os.path.splitext(os.path.basename(filename))
            extract_dir_local = extract_dir
        tfile.extractall(os.path.join(SRC_DIR, extract_dir_local))
        tfile.close()
    else:
        raise RuntimeError("Unknown compressed file format " + extension)

    # rename extracted folder to target_dir
    extract_dir_abs = os.path.join(SRC_DIR, extract_dir)
    os.rename(extract_dir_abs, target_dir)


# def downloadSCP(hostname, username, path, target_dir):
#     ssh = paramiko.SSHClient()
#     ssh.load_system_host_keys()
#     ssh.connect(hostname = hostname, username = username)
#     scpc = scp.SCPClient(ssh.get_transport())
#     scpc.get(path, local_path = target_dir);


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


def downloadAndExtractFile(url, target_dir_name, sha1_hash = None):
    p = urlparse(url)
    filename_rel = os.path.split(p.path)[1] # get original filename
    target_filename = os.path.join(ORIG_DIR, filename_rel)

    # check SHA1 hash, if file already exists
    force_download = False
    if os.path.exists(target_filename) and sha1_hash is not None and sha1_hash != "":
        hash_file = computeFileHash(target_filename)
        if hash_file != sha1_hash:
            log("Hash of " + target_filename + " (" + hash_file + ") does not match expected hash (" + sha1_hash + "); forcing download")
            force_download = True

    # download file
    if (not os.path.exists(target_filename)) or force_download:
        log("Downloading " + url + " to " + target_filename)
        # if p.scheme == "ssh":
        #     downloadSCP(p.hostname, p.username, p.path, ORIG_DIR)
        # else:
        #     urllib.urlretrieve(url, target_filename, reporthook = downloadProgress)
        urllib.urlretrieve(url, target_filename)
    else:
        log("Skipping download of " + url + "; already downloaded")

    # check SHA1 hash
    if sha1_hash is not None and sha1_hash != "":
        hash_file = computeFileHash(target_filename)
        if hash_file != sha1_hash:
            raise RuntimeError("Hash of " + target_filename + " (" + hash_file + ") differs from expected hash (" + sha1_hash + ")")

    extractFile(target_filename, os.path.join(SRC_DIR, target_dir_name))


def applyPatchFile(patch_name, dir_name):
    # we're assuming the patch was applied like in this example:
    # diff --exclude=".git" --exclude=".hg" -rupN ./src/AGAST/ ../external/src/AGAST/ > ./patches/agast.patch
    log("Applying patch to " + dir_name)
    patch_dir = os.path.join(BASE_DIR, "patches")
    arguments = "-d " + os.path.join(SRC_DIR, dir_name) + " -p3 < " + os.path.join(patch_dir, patch_name)
    res = executeCommand("patch --dry-run " + arguments, quiet = True)
    if res != 0:
        log("ERROR: patch application failure; has this patch already been applied?")
        executeCommand("patch --dry-run " + arguments, printCommand = True)
    else:
        dieIfNonZero(executeCommand("patch " + arguments, quiet = True))


def runScript(script_name):
    log("Running script " + script_name)
    patch_dir = os.path.join(BASE_DIR, "patches")
    filename = os.path.join(patch_dir, script_name)
    dieIfNonZero(executeCommand(filename, False));


def checkPrerequisites(*args):
    for arg in args:
        if (executeCommand("which " + arg, quiet = True) != 0):
            log("ERROR: " + arg + " not found")
            return -1
    return 0


def main():
    required_commands = ["git", "hg", "svn", "patch"]
    if (checkPrerequisites(*required_commands) != 0):
        log("The bootstrapping script requires that the following programs are installed: " + ", ".join(required_commands))
        return -1

    # create source directory
    if not os.path.isdir(SRC_DIR):
        log("Creating directory " + SRC_DIR)
        os.mkdir(SRC_DIR)

    # create original files directory
    if not os.path.isdir(ORIG_DIR):
        log("Creating directory " + ORIG_DIR)
        os.mkdir(ORIG_DIR)

    bootstrap_filename_abs = os.path.join(BASE_DIR, BOOTSTRAP_FILENAME)

    try:
        json_data = open(bootstrap_filename_abs).read()
    except:
        log("ERROR: Could not read JSON file " + bootstrap_filename_abs)
        return -1

    try:
        data = json.loads(json_data)
    except:
        log("ERROR: Could not parse JSON document")
        return -1

    for library in data:
        name = library.get('name', None)
        source = library.get('source', None)
        post = library.get('postprocess', None)

        if name is None:
            log("ERROR: Invalid schema: library object does not have a 'name'")
            return -1

        # create library directory, if necessary
        lib_dir = os.path.join(SRC_DIR, name)
        if not os.path.exists(lib_dir):
            os.mkdir(lib_dir)

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
                downloadAndExtractFile(src_url, name, source.get('sha1', None))
            else:
                cloneRepository(src_type, src_url, name, source.get('revision', None))
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
                applyPatchFile(post_file, name)
            elif post_type == "script":
                runScript(post_file)
            else:
                log("ERROR: Unknown post-processing type '" + post_type + "' for " + name)
                return -1

    return 0

if __name__ == "__main__":
    sys.exit(main())
