#!/usr/bin/env bash
# =============================================================================
#  download_data.sh  —  PULL everything (code + data) from the remotes
# -----------------------------------------------------------------------------
#  The reverse of upload_data.sh. Use on a fresh machine, after a teammate
#  pushed changes, or to restore data you deleted locally.
#    - git pull : gets latest code + .dvc pointers from GitHub
#    - dvc pull : downloads the matching dataset bytes from the DVC remote
#
#  Usage:
#    ./download_data.sh
# =============================================================================
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> [1/2] Pulling latest code + pointers from GitHub..."
git pull

echo "==> [2/2] Downloading matching dataset bytes from the DVC remote..."
dvc pull

echo ""
echo "Download complete. Your datasets are up to date."
