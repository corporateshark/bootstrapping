#!/usr/bin/env python

import os
import shutil

base_dir=os.getcwd()
lib_dir=os.path.join(base_dir, "src", "libcurl")

shutil.copyfile(os.path.join(base_dir, "patches", "libcurl", "curlbuild.h"), os.path.join(lib_dir, "include", "curl", "curlbuild.h"))
shutil.copyfile(os.path.join(base_dir, "patches", "libcurl", "curl_config.h"), os.path.join(lib_dir, "lib", "curl_config.h"))
shutil.copyfile(os.path.join(base_dir, "patches", "libcurl", "Android.mk"), os.path.join(lib_dir, "Android.mk"))
