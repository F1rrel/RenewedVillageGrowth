#!python

import os
import re
import platform
from shutil import copy2, rmtree, copytree
from glob import iglob
import tarfile

# ----------------------------------
# Definitions:
# ----------------------------------

# Game Script name
gs_name = "Renewed_Village_Growth"

# ----------------------------------


# Script:
version = -1
subversion = -1
for line in open("version.nut"):

	r = re.search('SELF_VERSION\s+<-\s+([0-9]+)', line)
	if(r != None):
		version = r.group(1)
	r2 = re.search('SELF_SUBVERSION\s+<-\s+([0-9]+)', line)
	if(r2 != None):
		subversion = r2.group(1)

if(version == -1 or subversion == -1):
	print("Couldn't find " + gs_name + " version in info.nut!")
	exit(-1)

if platform.system() == 'Linux':
    tmp_dir = gs_name + "-" + str(version) + "." + str(subversion)
    tar_name = tmp_dir + ".tar"

    if os.path.exists(tmp_dir):
        rmtree(tmp_dir)
    os.mkdir(tmp_dir)

    files = iglob("*.nut")
    for file in files:
        if os.path.isfile(file):
            copy2(file, tmp_dir)
    copy2('readme.txt', tmp_dir)
    #copy2('license.txt', tmp_dir)
    copy2('changelog.txt', tmp_dir)
    copytree('lang', os.path.join(tmp_dir, 'lang'))

    with tarfile.open(tar_name, "w:") as tar_handle:
        for root, dirs, files in os.walk(tmp_dir):
            for file in files:
                tar_handle.add(os.path.join(root, file))

    rmtree(tmp_dir)

elif platform.system() == 'Windows':
    dir_name = gs_name + "-" + str(version) + "." + str(subversion)
    tar_name = dir_name + ".tar"
    os.system("mkdir " + dir_name)
    os.system("xcopy /C /Y *.nut " + dir_name)
    os.system("xcopy /C /Y readme.txt " + dir_name)
    #os.system("xcopy /C /Y license.txt " + dir_name)
    os.system("xcopy /C /Y changelog.txt " + dir_name)
    os.system("xcopy /E /C /Y lang " + dir_name)
    os.system("tar -cf " + tar_name + " " + dir_name)
    os.system("rd /S /Q " + dir_name)

else:
    print("Unsupported OS")