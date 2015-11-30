#!/usr/bin/env python

import os
import shutil

base_dir=os.getcwd()
lib_dir=os.path.join(base_dir, "src", "libcurl")

shutil.copyfile(os.path.join(base_dir, "patches", "curlbuild.h"), os.path.join(lib_dir, "include", "curlbuild.h"))
