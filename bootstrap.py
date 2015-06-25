#pip install progressbar
#pip install paramiko
#pip install scp

import os
import subprocess
import shlex
import urlparse
import urllib
import zipfile
import tarfile

import progressbar
import paramiko
import scp

BASE_DIR = os.getcwd()
SRC_DIR = os.path.join(BASE_DIR, "src")
ORIG_DIR = os.path.join(BASE_DIR, "orig")

def executeCommand(command):
    print ">>> " + command
    res = subprocess.call(shlex.split(command));
    if res != 0:
        raise ValueError("Command returned non-zero status.");


def cloneRepository(type, url, target_name, revision = None):
    target_dir = os.path.join(SRC_DIR, target_name)
    print "Cloning " + url + " to " + target_dir

    if type == "hg":
        if not os.path.exists(target_dir):
            executeCommand("hg clone " + url + " " + target_dir)
        else:
            print "WARNING: directory " + target_dir + " already exists; pulling instead of cloning"
            executeCommand("hg pull -R " + target_dir)

        if revision is not None:
            executeCommand("hg update -R " + target_dir + " " + revision)
    elif type == "git":
        if not os.path.exists(target_dir):
            executeCommand("git clone " + url + " " + target_dir)
        else:
            print "WARNING: directory " + target_dir + " already exists; fetching instead of cloning"
            executeCommand("git -C " + target_dir + " fetch")

        if revision is not None:
            executeCommand("git -C " + target_dir + " reset --hard " + revision)
    elif type == "svn":
        if not os.path.exists(target_dir):
            executeCommand("svn checkout " + url + " " + target_dir)
        else:
            print "WARNING: directory " + target_dir + " already exists; PERFORMING NO ACTION!"

        if revision is not None:
            raise RuntimeError("Updating to revision not implemented for SVN.")
    else:
        raise ValueError("Cloning " + type + " repositories not implemented.")


def extractFile(filename, target_dir):
    if os.path.exists(target_dir):
        print "WARNING: Skipping file extraction of " + filename + "; target directory already exists"
        return

    print "Extracting file " + filename
    stem, extension = os.path.splitext(os.path.basename(filename))

    if extension == ".zip":
        zfile = zipfile.ZipFile(filename)
        zfile.extractall(SRC_DIR)
        extract_dir = os.path.commonprefix(zfile.namelist())
        zfile.close()
    elif extension == ".gz" or extension == ".bz2":
        tfile = tarfile.open(filename)
        tfile.extractall(SRC_DIR)
        extract_dir = os.path.commonprefix(tfile.getnames())
        tfile.close()

    # rename extracted folder to target_dir
    extract_dir_abs = os.path.join(SRC_DIR, extract_dir)
    os.rename(extract_dir_abs, target_dir)


def downloadSCP(hostname, username, path, target_dir):
    ssh = paramiko.SSHClient()
    ssh.load_system_host_keys()
    ssh.connect(hostname = hostname, username = username)
    scpc = scp.SCPClient(ssh.get_transport())
    scpc.get(path, local_path = target_dir);


def downloadProgress(count, block_size, total_size):
    global pbar
    if count == 0:
        pbar = progressbar.ProgressBar(maxval = total_size / block_size)
    else:
        pbar.update(count - 1)


def downloadAndExtractFile(url, target_dir_name):
    p = urlparse.urlparse(url)
    filename_rel = os.path.split(p.path)[1] # get original filename
    target_filename = os.path.join(ORIG_DIR, filename_rel)

    if not os.path.exists(target_filename):
        print "Downloading " + url + " to " + target_filename
        if p.scheme == "ssh":
            downloadSCP(p.hostname, p.username, p.path, ORIG_DIR)
        else:
            urllib.urlretrieve(url, target_filename, reporthook = downloadProgress)
    else:
        print "Skipping download of " + url + "; already downloaded"

    extractFile(target_filename, os.path.join(SRC_DIR, target_dir_name))


def applyPatchFile(filename, directory):
    # TODO: implement
    pass;


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
    downloadAndExtractFile("http://downloads.sourceforge.net/project/agastpp/v1_1/agast%2B%2B_1_1.tar.gz", "AGAST")

    downloadAndExtractFile("http://zlib.net/zlib-1.2.8.tar.gz", "zlib")
    downloadAndExtractFile("http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz", "bzip2")
    downloadAndExtractFile("http://www.ijg.org/files/jpegsrc.v9a.tar.gz", "libjpeg")
    downloadAndExtractFile("http://downloads.sourceforge.net/libpng/libpng-1.6.17.tar.gz", "libpng")
    downloadAndExtractFile("http://downloads.sourceforge.net/giflib/giflib-5.1.1.tar.gz", "giflib")

    downloadAndExtractFile("http://downloads.sourceforge.net/project/boost/boost/1.58.0/boost_1_58_0.tar.bz2", "boost")

    downloadAndExtractFile("http://downloads.sourceforge.net/project/dclib/dlib/v18.16/dlib-18.16.tar.bz2", "dlib")
    downloadAndExtractFile("http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz", "libiconv")

    cloneRepository("git", "https://github.com/philsquared/Catch.git", "Catch")
    cloneRepository("svn", "http://googletest.googlecode.com/svn/tags/release-1.7.0", "googletest")

    cloneRepository("hg", "ssh://hg@bitbucket.org/eigen/eigen", "Eigen", "b9210aebb4dd4ba8bea7e5ba9dc4242a380be9cc")
    cloneRepository("git", "https://github.com/miloyip/rapidjson.git", "rapidjson", "eb53791411a5c6466fd38021ff832f71ac17231f")
    cloneRepository("git", "https://github.com/lastfm/last.json.git", "lastfm-last.json", "85fd751646b67be81dd3535e164d8faced54f4e0")
    cloneRepository("git", "https://github.com/zxing/zxing", "zxing", "542319c18f4c5ae41059e6187b1cc94aeba6b0d8")
    cloneRepository("git", "https://github.com/jlblancoc/nanoflann.git", "nanoflann")
    cloneRepository("git", "https://github.com/google/snappy.git", "snappy")
    cloneRepository("git", "https://github.com/vlfeat/vlfeat.git", "vlfeat")
    cloneRepository("hg", "https://code.google.com/p/poly2tri", "poly2tri")

    # TODO: how can we reconstruct the following directories from the old repository?
    # - maxsum
    # - Windows

    # TODO: apply necessary patches

if __name__ == "__main__":
    main()
