#!/bin/bash
mkdir ~/bin
PATH=~/bin:$PATH
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
mkdir WORKING_DIRECTORY2
cd WORKING_DIRECTORY2
git config --global user.name "ST"
git config --global user.email "samtronxindia@gmail.com"
repo init -u https://android.googlesource.com/platform/manifest
repo sync 
. build/envsetup.sh
