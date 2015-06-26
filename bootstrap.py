#!/usr/bin/env python

# Dependencies (not needed at the moment; commented out below)
# > pip install progressbar
# > pip install paramiko
# > pip install scp

import os
import subprocess
import urlparse
import urllib
import zipfile
import tarfile

#import progressbar
#import paramiko
#import scp

BASE_DIR = os.getcwd()
SRC_DIR = os.path.join(BASE_DIR, "src")
ORIG_DIR = os.path.join(BASE_DIR, "orig")

def executeCommand(command, verbose = True):
    if verbose:
        print ">>> " + command
    res = subprocess.call(command, shell = True);
    if res != 0:
        raise ValueError("Command returned non-zero status.");


def cloneRepository(type, url, target_name, revision = None):
    target_dir = os.path.join(SRC_DIR, target_name)
    print "Cloning " + url + " to " + target_dir

    if type == "hg":
        if not os.path.exists(target_dir):
            executeCommand("hg clone " + url + " " + target_dir)
        else:
            print "Directory " + target_dir + " already exists; pulling instead of cloning"
            executeCommand("hg pull -R " + target_dir)

        if revision is not None:
            executeCommand("hg update -R " + target_dir + " " + revision)
    elif type == "git":
        if not os.path.exists(target_dir):
            executeCommand("git clone " + url + " " + target_dir)
        else:
            print "Directory " + target_dir + " already exists; fetching instead of cloning"
            executeCommand("git -C " + target_dir + " fetch")

        if revision is not None:
            executeCommand("git -C " + target_dir + " reset --hard " + revision)
    elif type == "svn":
        if not os.path.exists(target_dir):
            executeCommand("svn checkout " + url + " " + target_dir)
        else:
            print "Directory " + target_dir + " already exists; PERFORMING NO ACTION!"

        if revision is not None:
            raise RuntimeError("Updating to revision not implemented for SVN.")
    else:
        raise ValueError("Cloning " + type + " repositories not implemented.")


def extractFile(filename, target_dir):
    if os.path.exists(target_dir):
        print "Skipping file extraction of " + filename + "; target directory already exists"
        return

    print "Extracting file " + filename
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
    elif extension == ".gz" or extension == ".bz2":
        tfile = tarfile.open(filename)
        extract_dir = os.path.commonprefix(tfile.getnames())
        extract_dir_local = ""
        if extract_dir == "":  # deal with stupid tar files that don't contain a base directory
            extract_dir, extension2 = os.path.splitext(os.path.basename(filename))
            extract_dir_local = extract_dir
        tfile.extractall(os.path.join(SRC_DIR, extract_dir_local))
        tfile.close()

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


def downloadAndExtractFile(url, target_dir_name):
    p = urlparse.urlparse(url)
    filename_rel = os.path.split(p.path)[1] # get original filename
    target_filename = os.path.join(ORIG_DIR, filename_rel)

    if not os.path.exists(target_filename):
        print "Downloading " + url + " to " + target_filename
        # if p.scheme == "ssh":
        #     downloadSCP(p.hostname, p.username, p.path, ORIG_DIR)
        # else:
        #     urllib.urlretrieve(url, target_filename, reporthook = downloadProgress)
        urllib.urlretrieve(url, target_filename)
    else:
        print "Skipping download of " + url + "; already downloaded"

    extractFile(target_filename, os.path.join(SRC_DIR, target_dir_name))


def applyPatchFile(patch_name, dir_name):
    # we're assuming the patch was applied like in this example:
    # diff --exclude=".git" --exclude=".hg" -rupN ./src/AGAST/ ../external/src/AGAST/ > ./patches/agast.patch
    print "Applying patch to " + dir_name
    src_dir = os.path.join(SRC_DIR, dir_name)
    patch_dir = os.path.join(BASE_DIR, "patches")
    if not os.path.exists(src_dir):
        os.mkdir(src_dir)
    executeCommand("patch -d " + os.path.join(SRC_DIR, dir_name) + "/ -p3 < " + os.path.join(patch_dir, patch_name) + ".patch")


def runScript(script_name):
    print "Running script " + script_name
    patch_dir = os.path.join(BASE_DIR, "patches")
    filename = os.path.join(patch_dir, script_name)
    executeCommand(filename, False);


def main():
    # create source directory
    if not os.path.isdir(SRC_DIR):
        print "Creating directory " + SRC_DIR
        os.mkdir(SRC_DIR)

    # create original files directory
    if not os.path.isdir(ORIG_DIR):
        print "Creating directory " + ORIG_DIR
        os.mkdir(ORIG_DIR)

    # TODO: use JSON schema to describe repositories instead of hardcoding them here

    downloadAndExtractFile("http://www.edwardrosten.com/work/fast-C-src-2.1.zip", "FAST")
    applyPatchFile("fast", "FAST")
    downloadAndExtractFile("http://downloads.sourceforge.net/project/agastpp/v1_1/agast%2B%2B_1_1.tar.gz", "AGAST")
    applyPatchFile("agast", "AGAST")
    downloadAndExtractFile("http://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.bz2", "boost")
    downloadAndExtractFile("http://zlib.net/zlib-1.2.8.tar.gz", "zlib")
    downloadAndExtractFile("http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz", "bzip2")
    downloadAndExtractFile("http://www.ijg.org/files/jpegsrc.v9a.tar.gz", "libjpeg")
    runScript("libjpeg.sh")
    downloadAndExtractFile("http://downloads.sourceforge.net/libpng/libpng-1.6.17.tar.gz", "libpng")
    runScript("libpng.sh")
    downloadAndExtractFile("http://downloads.sourceforge.net/giflib/giflib-5.1.0.tar.gz", "giflib")
    applyPatchFile("giflib", "giflib")
    downloadAndExtractFile("http://downloads.sourceforge.net/project/dclib/dlib/v18.16/dlib-18.16.tar.bz2", "dlib")
    downloadAndExtractFile("http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz", "libiconv")
    applyPatchFile("libiconv", "libiconv")
    cloneRepository("git", "https://github.com/philsquared/Catch.git", "Catch")
    cloneRepository("svn", "http://googletest.googlecode.com/svn/tags/release-1.7.0", "googletest")
    cloneRepository("hg", "ssh://hg@bitbucket.org/eigen/eigen", "eigen", "b9210aebb4dd4ba8bea7e5ba9dc4242a380be9cc")
    applyPatchFile("eigen", "eigen")
    cloneRepository("git", "https://github.com/miloyip/rapidjson.git", "rapidjson", "eb53791411a5c6466fd38021ff832f71ac17231f")
    cloneRepository("git", "https://github.com/lastfm/last.json.git", "lastfm-last.json", "85fd751646b67be81dd3535e164d8faced54f4e0")
    cloneRepository("git", "https://github.com/zxing/zxing", "zxing", "00f634024ceeee591f54e6984ea7dd666fab22ae")
    applyPatchFile("zxing", "zxing")
    cloneRepository("git", "https://github.com/jlblancoc/nanoflann.git", "nanoflann")
    cloneRepository("git", "https://github.com/google/snappy.git", "snappy")
    cloneRepository("git", "https://github.com/vlfeat/vlfeat.git", "vlfeat")
    cloneRepository("hg", "https://code.google.com/p/poly2tri", "poly2tri")
    applyPatchFile("maxsum", "maxsum")
    applyPatchFile("Windows", "Windows")

    cloneRepository("git", "http://repo.or.cz/openal-soft.git", "openal-soft")
    downloadAndExtractFile("http://wss.co.uk/pinknoise/tremolo/Tremolo001.zip", "libtremolo")
    downloadAndExtractFile("http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz", "libogg")
    downloadAndExtractFile("http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz", "libvorbis")
    downloadAndExtractFile("http://downloads.sourceforge.net/project/modplug-xmms/libmodplug/0.8.8.5/libmodplug-0.8.8.5.tar.gz", "libmodplug")

if __name__ == "__main__":
    main()
