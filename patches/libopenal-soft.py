#!/usr/bin/env python

import os
import shutil

base_dir=os.getcwd()
lib_dir=os.path.join(base_dir, "src", "openal-soft")

shutil.copyfile(os.path.join(base_dir, "patches", "openal-soft-config.h"), os.path.join(lib_dir, "include", "config.h"))
