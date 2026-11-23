# AOSP download script

A simple download script for the Android source code (AOSP).

It follows the official instructions:

- Requirements and Repo install: https://source.android.com/docs/setup/start/requirements
- Downloading the source: https://source.android.com/docs/setup/download
- Building: https://source.android.com/docs/setup/build/building

## Requirements

- 64-bit x86 Linux (Ubuntu 18.04 or later; macOS is not supported)
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
