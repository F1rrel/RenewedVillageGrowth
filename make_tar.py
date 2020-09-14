#!python

import os
import re
import platform
from shutil import copy2, rmtree, copytree
from glob import iglob
import tarfile
from pathlib import Path

# ----------------------------------
# Definitions:
# ----------------------------------

# Game Script name
gs_name = "Renewed_Village_Growth"

# ----------------------------------


# Script:
mainversion = -1
subversion = -1
with open("version.nut", 'r+') as file:
    for line in file:
        r = re.search('SELF_MAJORVERSION\s+<-\s+([0-9]+)', line)
        if(r != None):
            mainversion = r.group(1)
        r2 = re.search('SELF_MINORVERSION\s+<-\s+([0-9]+)', line)
        if(r2 != None):
            subversion = r2.group(1)

if(mainversion == -1 or subversion == -1):
    print("Couldn't find " + gs_name + " version in info.nut!")
    exit(-1)

tmp_dir = gs_name + "-" + str(mainversion) + "." + str(subversion)
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

game_folder = Path("./../../game/")
copy2(tar_name, game_folder)