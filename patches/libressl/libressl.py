#!/usr/bin/env python

import os
import shutil

base_dir=os.getcwd()
lib_dir=os.path.join(base_dir, "src", "libressl")

shutil.copyfile(os.path.join(base_dir, "patches", "libressl", "Android.mk"), os.path.join(lib_dir, "Android.mk"))
shutil.copyfile(os.path.join(base_dir, "patches", "libressl", "android-config.mk"), os.path.join(lib_dir, "android-config.mk"))
shutil.copyfile(os.path.join(base_dir, "patches", "libressl", "Android_crypto.mk"), os.path.join(lib_dir, "crypto", "Android.mk"))
shutil.copyfile(os.path.join(base_dir, "patches", "libressl", "Android_ssl.mk"), os.path.join(lib_dir, "ssl", "Android.mk"))
shutil.copyfile(os.path.join(base_dir, "patches", "libressl", "opensslconf.h"), os.path.join(lib_dir, "include", "openssl", "opensslconf.h"))
shutil.copyfile(os.path.join(base_dir, "patches", "libressl", "getentropy_android.c"), os.path.join(lib_dir, "crypto", "compat", "getentropy_android.c"))
shutil.copyfile(os.path.join(base_dir, "patches", "libressl", "reallocarray.c"), os.path.join(lib_dir, "crypto", "compat", "reallocarray.c"))
