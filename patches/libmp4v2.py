#!/usr/bin/env python

import os
import shutil

base_dir=os.getcwd()
lib_dir=os.path.join(base_dir, "src", "mp4v2")

shutil.copyfile(os.path.join(base_dir, "patches", "mp4v2_config.h"), os.path.join(lib_dir, "libplatform", "config.h"))
