# 👢 Bootstrap

The Bootstrap script is a versatile dependencies manager for your C++
projects. You can think of it as a portable (Windows, Linux, OSX) and a more
feature-complete alternative to Google's Repo tool. The script itself is written 
in Python and should "just work" using any standard Python&nbsp;3 installation.

## Introduction

Main features of Bootstrap:
-  One-button-download philosophy. Just run the script to download and update all your dependencies.
-  Cross-platform. Runs on Windows, Linux, and OSX.
-  Full support of Git, Mercurial, SVN repositories.
-  Full support of `.zip`, `.tar`, `.gz`, `.bz2`, `.xz` archives.
-  Caching and fallback mechanisms.
-  Rich error reporting.

## Usage

For instance, this minimalistic JSON snippet will clone the GLFW library from its Git repository
and check out the revision which is tagged `3.3`.

```JSON
[{
    "name": "glfw",
    "source": {
        "type": "git",
        "url": "https://github.com/glfw/glfw.git",
        "revision": "3.3"
    }
}]
```

This simple JSON snippet will download the `libjpeg` library from
the specified URL (via a custom user-agent string), check the archive integrity
via SHA1, unpack the archive, and put its content into the `src/libjpeg` folder:

```JSON
[{
    "name": "libjpeg",
    "source": {
        "type": "archive",
        "url": "http://www.ijg.org/files/jpegsrc.v9a.tar.gz",
        "sha1": "d65ed6f88d318f7380a3a5f75d578744e732daca",
        "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36"
    }
}]
```

This JSON snippet will download the `nestegg` library from the Git repository,
checkout the specified revision, and apply a patch via a custom Python script.

```JSON
[{
    "name": "nestegg",
    "source": {
        "type": "git",
        "url": "https://github.com/kinetiknz/nestegg",
        "revision": "8374e436ad90afd61919ffe27aa5ff2887feacba"
    },
    "postprocess": {
        "type": "script",
        "file": "libnestegg.py"
    }
}]
```

Read the comprehensive documentation below for further details.

## P.S.

This is a fork of an abandoned library https://bitbucket.org/blippar/bootstrapping-external-libs

------------------------------------------------------------------------------
Original documentation:
------------------------------------------------------------------------------

This repository holds our external (i.e. third party) libraries. After a fresh
clone, the repository contains *only* metadata about the libraries, i.e. their
names, where to retrieve them from, etc. In order to actually obtain or update
the libraries, the user must run a bootstrapping script, which downloads all
third-party libraries and places them into a src/ directory.


Prerequisites
-------------

The script itself is written in Python and should "just work" using any standard
Python 2 or 3 installation. The version control tools Git, Mercurial and
Subversion must be installed and available on the environment path; in addition,
the 'patch' program must be present on the user's system. On Windows, the script
can be run from the command line (for patching to work, ensure you have the Cygwin
patch tool installed).


Obtaining the libraries
-----------------------

Run the bootstrapping script from the repository's top-level directory:
> python bootstrap.py
or just:
> ./bootstrap.py

The script should run without any errors or exceptions raised. Third-party
library sources are either downloaded as a packaged archive file (e.g. .zip,
.tar.gz, .tar.bz2) and then uncompressed, or cloned directly from the original
repository. All source code is obtained from the respective authorative sources,
i.e. directly from the authors' websites or repositories.

After script execution has finished, the following files and directories should
have been added to the repository folder:

```
    |- external
       |- .bootstrap.json
       |- archives/
          |- ...
       |- snapshots/
          |- ...
       |- src/
          |- ...
```

- The file .bootstrap.json contains the cached state of the last bootstrapping/
pdating operation. The script always compares against this state, in order to
decide whether to update a library. For example, if boostrap.py has executed
successfully and is then immediately re-run, no further action will take place.

- The directory archives/ contains the archive files of all libraries that have
been downloaded as archives. It serves as a cache to prevent multiple downloads.

- The directory snapshots/ serves as a cache for snapshots of a complete
repository. It will only be created if the --repo-snapshots option was specified
on the command line. This will enable the respective copy of the 'external'
repository to serve as a fallback location.

- The directory src/ contains all third-party library sources. Libraries that
were obtained in archive form will have been uncompressed into this directory.
Libraries that were obtained from a repository (Git, Mercurial or SVN) will have
been cloned into this directory.


Adding or changing the version of a library
-------------------------------------------

All metadata about the third-party libraries and their versions is contained in
a single JSON file (bootstrap.json) that is being read by the script.

The file should contain exactly one JSON array of objects, where each object
contained in this array describes one library. This JSON schema gives an
overview of the format:

```
[
{
    "name": "LibraryName",
    "source": {
        "type": "archive|git|hg|svn",
        "url": "http://...",
        "sha1": "0123456789...0123456789",  # for type == archive
        "revision": "0123456789"  # for type == git|hg|svn
    },
    "postprocess": {
        "type": "patch|script",
        "file": "filename"
    }
},
{
    ...
},
...
]
```

The library "name" specifies the name of the library, which in turn specifies
the subdirectory name under the src/ directory. The name should be the common
name of the library (e.g. "libjpeg") and *not* contain any particular version
numbers or other information that may change between versions.

For each library, the "source" field contains information about where to obtain
the library from, in the form of a JSON object.

The source "type" field can be one of the following types: "archive", "git",
"hg", or "svn". The first type describes an archive file (such as .zip, .tar.gz,
.tar.bz2 files), while the last three types describe different repository types.

The "url" value contains the URL of the archive to be downloaded in case the
type is 'archive', and the respository URL otherwise.

If the source type is 'archive', then the optional "sha1" field can (and should)
be used to add the SHA1 hash of the archive, for verification purposes.

For repositories (i.e. type is 'git|hg|svn'), an optional "revision" field can
specify the particular revision/commit to be checked out. If the revision field
is omitted, the default is to check out the HEAD revision of the master branch
(for Git repositories), or the tip of the default branch (for Mercurial
repositories).

The "postprocess" field contains an object which describes any optional post-
processing steps, once the original library sources have been put into the src/
directory. Post-processing can be of type "patch" or "script"; in both cases,
the filename has to be given in the "file" field.

For type 'patch', the file field specifies a patch file to be contained in the
patches/ directory. For type 'file', the file field specified a script that is
run from the patches/ directory. Patches can be used to make minor modifications
to a library, such as silencing warning or to fix bugs which have not been
included in the upstream version of the library. Scripts can embody any more
complex operations, but should mainly be used for simple library-specific
prerequisites (such as copying header prototype files). All scripts have to
be written in Python, in order to be compatible with all platforms, including
Windows.

Patches should be created using the `diff` program from the external/ directory,
similar to this example:
```
> diff --exclude=".git" --exclude=".hg" -rupN \
      ./src/AGAST/ ./src/AGAST_patched/ > ./patches/agast.patch
```
The default -p argument for the patch command is 3, but this can be changed by
an optional "pnum" field inside the postprocessing JSON object, containing a
numeric value.
For example, for patches created using `git diff` or `hg diff`, a "pnum"
argument of "1" is likely needed. This method of creating a patch is
discouraged, however, in favor of the cleaner method using the plain 'diff'
command described above.

In general, only ever add or modify libraries in a way that is compatible with
how it's already done. See also the next section.


Policies for adding or updating a library
-----------------------------------------

- IMPORTANT: There shall be NO committed source code of any kind in this
repository (besides patches). All source code shall be downloaded from the
respective authorative sources, i.e. the library authors' web sites (zipped or
tarred packages) or repositories.

- IMPORTANT: There shall be NO committed binary files of any kind in this
repository. Binary files are to be built using the respective platform-specific
build system, and are to not be committed anywhere in the first place.

- The bootstrapping script should always run cleanly, with no further action
required from the user.

- All repositories should be in their final usable state after running the
bootstrapping script, i.e. the committed makefiles should be usable.

- Any patches to a library should be kept minimal. Larger changes to a
third-party code base are discouraged.

- If we really have to patch a library, e.g. to fix a bug or to silence a
warning, let's try to get our patch accepted upstream. If we then update to a
newer version of the library, we won't need a patch file anymore.

- All patch files should adhere to the naming
  <library_name>_<sha1_hash>.patch
where <sha1_hash> is the hash of either the archive file or the repository.
This enables to keep multiple patches for the same library, in case different
project need different versions of a library (via using local bootstrapping
files).

- The canonical bootstrapping JSON file should always contain the respective
latest version of each library that is used across our codebase. If a library
is updated, it should be updated to the respective latest version available.

- We should be keeping the contained library versions reasonably up-to-date.


License
-------
See the LICENSE file

Bug reports, comments
---------------------

Should go to omar@blippar.com.
