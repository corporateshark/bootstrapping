#!/usr/bin/env python

import os
import shutil

base_dir=os.getcwd()
lib_dir=os.path.join(base_dir, "src", "libjpeg")

shutil.copyfile(os.path.join(lib_dir, "jconfig.txt"), os.path.join(lib_dir, "jconfig.h"))
