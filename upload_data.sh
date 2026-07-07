#!/usr/bin/env bash
# =============================================================================
#  upload_data.sh  —  PUSH everything (code + data) to their remotes
# -----------------------------------------------------------------------------
#  The golden rule: git and dvc travel together.
#    - git push : sends code + .dvc pointer files  -> GitHub
#    - dvc push : sends the actual dataset bytes    -> DVC remote (/home/ubuntu/DVC)
#
#  Run this after ./version_data.sh so your new version is safely backed up.
#
#  Usage:
#    ./upload_data.sh
# =============================================================================
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> [1/2] Pushing code + pointers to GitHub..."
git push

echo "==> [2/2] Pushing dataset bytes to the DVC remote..."
dvc push

echo ""
echo "Upload complete. Verify with:  ./check_status.sh"
