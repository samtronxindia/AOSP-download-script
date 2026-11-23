#!/bin/bash
#
# Download the Android source code (AOSP), following
#   https://source.android.com/docs/setup/start/requirements
#   https://source.android.com/docs/setup/download
#
# Usage:
#   ./aosp_dl.sh [WORKING_DIRECTORY]
#
# Optional environment variables:
#   AOSP_BRANCH   branch or tag to check out (default: android-latest-release)
#   AOSP_JOBS     parallel sync jobs         (default: 8)
#   SKIP_PACKAGES set to 1 to skip the apt-get package install

set -euo pipefail

WORKING_DIRECTORY="${1:-$HOME/aosp}"
AOSP_BRANCH="${AOSP_BRANCH:-android-latest-release}"
AOSP_JOBS="${AOSP_JOBS:-8}"
MANIFEST_URL="https://android.googlesource.com/platform/manifest"
REPO_KEY="8BB9AD793E8E6153AF0F9A4416530D5E920F5C65"

# --- 1. Required packages (Ubuntu 18.04 or later) ---------------------------
if [ "${SKIP_PACKAGES:-0}" != "1" ]; then
    sudo apt-get update
    sudo apt-get install -y git-core gnupg flex bison build-essential zip curl \
        zlib1g-dev libc6-dev-i386 x11proto-core-dev libx11-dev lib32z1-dev \
        libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig
fi

# --- 2. Repo ----------------------------------------------------------------
mkdir -p "$HOME/bin"
export PATH="$HOME/bin:$PATH"

if ! command -v repo >/dev/null 2>&1; then
    # Try the distribution package first, then fall back to a verified
    # manual install.
    if [ "${SKIP_PACKAGES:-0}" = "1" ] || ! sudo apt-get install -y repo; then
        REPO_TMP="$(mktemp /tmp/repo.XXXXXXXXX)"
        curl -o "$REPO_TMP" https://storage.googleapis.com/git-repo-downloads/repo
        gpg --recv-keys "$REPO_KEY"
        curl -s https://storage.googleapis.com/git-repo-downloads/repo.asc \
            | gpg --verify - "$REPO_TMP"
        install -m 755 "$REPO_TMP" "$HOME/bin/repo"
        rm -f "$REPO_TMP"
    fi
fi
repo version

# --- 3. Git identity --------------------------------------------------------
# Repo needs a name and email. Set yours once, then re-run this script:
#   git config --global user.name  "Your Name"
#   git config --global user.email "you@example.com"
if ! git config --get user.name >/dev/null || ! git config --get user.email >/dev/null; then
    echo "error: git user.name / user.email are not set." >&2
    echo "  git config --global user.name  \"Your Name\"" >&2
    echo "  git config --global user.email \"you@example.com\"" >&2
    exit 1
fi

# --- 4. Working directory ---------------------------------------------------
mkdir -p "$WORKING_DIRECTORY"
cd "$WORKING_DIRECTORY"

# The source checkout needs about 250 GB; a build needs about 150 GB more.
FREE_GB="$(df -BG --output=avail . | tail -1 | tr -dc '0-9')"
if [ "$FREE_GB" -lt 250 ]; then
    echo "warning: only ${FREE_GB} GB free in $WORKING_DIRECTORY;" \
         "the checkout needs ~250 GB (400 GB to also build)." >&2
fi

# --- 5. Initialize and sync -------------------------------------------------
repo init --partial-clone --no-use-superproject \
    -b "$AOSP_BRANCH" -u "$MANIFEST_URL"
repo sync -c -j"$AOSP_JOBS"

# --- 6. Next steps ----------------------------------------------------------
cat <<EOF

Download complete: $WORKING_DIRECTORY ($AOSP_BRANCH)

To build (these must run in your own shell, not from this script):
  cd $WORKING_DIRECTORY
  source build/envsetup.sh
  lunch aosp_cf_x86_64_only_phone-aosp_current-userdebug
  m
EOF
