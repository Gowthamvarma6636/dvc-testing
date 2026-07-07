#!/usr/bin/env bash
# =============================================================================
#  version_data.sh  —  create a new VERSION of a dataset with DVC
# -----------------------------------------------------------------------------
#  Use this whenever a dataset FOLDER changes (added / removed / relabeled
#  files) OR when you want to start tracking a NEW dataset.
#
#  What it does:
#    1. dvc add <dataset>     -> re-hash the folder, update the .dvc pointer
#    2. git add  <pointer> .gitignore
#    3. git commit            -> record this dataset version in git history
#
#  It does NOT push. Run ./upload_data.sh afterwards to back it up.
#
#  Usage:
#    ./version_data.sh <dataset_folder> "your commit message"
#  Example:
#    ./version_data.sh 06-07-26_cumi "Added 500 new helmet images"
# =============================================================================
set -euo pipefail

# Always run from the repo root (folder this script lives in)
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DATASET="${1:-}"
MESSAGE="${2:-}"

if [[ -z "$DATASET" || -z "$MESSAGE" ]]; then
  echo "Usage: ./version_data.sh <dataset_folder> \"commit message\""
  echo "Example: ./version_data.sh 06-07-26_cumi \"Added 500 new images\""
  exit 1
fi

if [[ ! -d "$DATASET" ]]; then
  echo "ERROR: dataset folder '$DATASET' not found in $(pwd)"
  exit 1
fi

echo "==> [1/3] Hashing & caching '$DATASET' with DVC (this can take a while)..."
dvc add "$DATASET"

echo "==> [2/3] Staging the pointer file in git..."
git add "${DATASET}.dvc" .gitignore

if git diff --cached --quiet; then
  echo "Nothing changed — '$DATASET' is already at this version. Done."
  exit 0
fi

echo "==> [3/3] Committing version to git history..."
git commit -m "$MESSAGE"

echo ""
echo "Version created. Next step -> back it up:  ./upload_data.sh"
