#!/usr/bin/python

import os
import shutil

base_dir=os.getcwd()
lib_dir=os.path.join(base_dir, "src", "libpng")

shutil.copyfile(os.path.join(lib_dir, "scripts", "pnglibconf.h.prebuilt"), os.path.join(lib_dir, "pnglibconf.h"))
