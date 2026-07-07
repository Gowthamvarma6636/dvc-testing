#!/usr/bin/env bash
# =============================================================================
#  check_status.sh  —  see the state of code, data, and backups
# -----------------------------------------------------------------------------
#  Answers three questions:
#    1. git status  : any code / pointer changes not committed?
#    2. dvc status  : any dataset changes not yet 'dvc add'-ed (new version)?
#    3. dvc status -c: is my data safely backed up to the remote?
#
#  Usage:
#    ./check_status.sh
# =============================================================================
set -uo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=================================================================="
echo " 1) GIT  — uncommitted code / pointer changes"
echo "=================================================================="
git status -s
git status -sb | head -1
echo ""

echo "=================================================================="
echo " 2) DVC  — dataset changes not yet versioned (run version_data.sh)"
echo "=================================================================="
dvc status

echo ""
echo "=================================================================="
echo " 3) DVC REMOTE — is the data backed up? (run upload_data.sh if not)"
echo "=================================================================="
dvc status -c
