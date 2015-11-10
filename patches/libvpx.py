#!/usr/bin/env python

import os
import shutil

base_dir=os.getcwd()
lib_dir=os.path.join(base_dir, "src", "libvpx")

files = [
"vp9_rtcd.h",
"vp9_rtcd_armv7-android-gcc.h",
"vp9_rtcd_generic-gnu.h",
"vp9_rtcd_x86-win32-vs12.h",
"vp9_rtcd_x86_64-win64-vs12.h",
"vpx_config.h",
"vpx_dsp_rtcd.h",
"vpx_dsp_rtcd_armv7-android-gcc.h",
"vpx_dsp_rtcd_generic-gnu.h",
"vpx_dsp_rtcd_x86-win32-vs12.h",
"vpx_dsp_rtcd_x86_64-win64-vs12.h",
"vpx_scale_rtcd.h",
"vpx_scale_rtcd_armv7-android-gcc.h",
"vpx_scale_rtcd_generic-gnu.h",
"vpx_scale_rtcd_x86-win32-vs12.h",
"vpx_scale_rtcd_x86_64-win64-vs12.h",
"vpx_version.h"]

for File in files:
	shutil.copyfile(os.path.join(base_dir, "patches", "libvpx", File), os.path.join(lib_dir, File))
