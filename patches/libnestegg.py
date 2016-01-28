#!/usr/bin/env python

import os
import shutil

base_dir=os.getcwd()
lib_dir=os.path.join(base_dir, "src", "nestegg")

shutil.copyfile(os.path.join(base_dir, "patches", "nestegg", "nestegg-stdint.h"), os.path.join(lib_dir, "include", "nestegg", "nestegg-stdint.h"))
