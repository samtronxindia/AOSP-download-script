# AOSP download script: download the Android Open Source Project source code

A simple Bash script that downloads the Android source code (AOSP, the Android Open Source Project) on Ubuntu Linux using the `repo` tool, ready to build Android from source.

It is meant for students, researchers and developers who need a full Android platform checkout: Android security research, SELinux policy and access control work, Android framework and system internals, kernel and HAL development, custom ROM builds, and running AOSP on the Cuttlefish emulator or Pixel devices.

It follows the official instructions:

- Requirements and Repo install: https://source.android.com/docs/setup/start/requirements
- Downloading the source: https://source.android.com/docs/setup/download
- Building: https://source.android.com/docs/setup/build/building

## Requirements

- A 64-bit x86 machine running a 64-bit Linux distribution with glibc 2.17 or later
- On Ubuntu: 18.04 or later, which Google's requirements page gives as the minimum for building Android 11 or higher. The page names no newer release as tested or recommended.
- The package list this script installs is the one Google gives for Ubuntu 18.04 or later
- macOS is not supported for Android OS development (since Android 11)
- At least 64 GB of RAM to build
- At least 400 GB of free disk space (about 250 GB for the checkout, 150 GB for a build)

## Usage

Set your name and email for git, if you have not already:

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
```

Then run the script, optionally giving the directory to download into (default `~/aosp`):

```bash
chmod +x aosp_dl.sh
./aosp_dl.sh ~/aosp
```

The script:

1. Installs the required packages with `apt-get` (asks for `sudo`).
2. Installs Repo, from the `repo` package or, failing that, by a signature-verified manual download to `~/bin/repo`.
3. Runs `repo init --partial-clone --no-use-superproject -b android-latest-release -u https://android.googlesource.com/platform/manifest`.
4. Runs `repo sync -c -j8`.

## Options

| Variable | Default | Meaning |
| --- | --- | --- |
| `AOSP_BRANCH` | `android-latest-release` | Branch or tag to check out (see the [build numbers list](https://source.android.com/docs/setup/reference/build-numbers)) |
| `AOSP_JOBS` | `8` | Parallel jobs for `repo sync` |
| `SKIP_PACKAGES` | `0` | Set to `1` to skip the `apt-get` steps |

Example:

```bash
AOSP_BRANCH=android-16.0.0_r1 AOSP_JOBS=16 ./aosp_dl.sh ~/aosp16
```

## Building

After the download finishes, in your own shell:

```bash
cd ~/aosp
source build/envsetup.sh
lunch aosp_cf_x86_64_only_phone-aosp_current-userdebug
m
```

## Keywords

AOSP, Android Open Source Project, download Android source code, AOSP download script, repo init, repo sync, android-latest-release, build Android from source, AOSP build environment setup, Ubuntu, Cuttlefish, Pixel, Android platform development, Android security research, SELinux, Android internals, custom ROM, operating systems course.
