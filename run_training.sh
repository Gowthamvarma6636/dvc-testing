#!/usr/bin/env bash
# Resilient launcher for YOLO training on this 15GB-RAM box.
#
# Why this exists: training was OOM-killed twice at the tail of long runs
# (Jun25 & Jul06) because cache=True RAM-cached the ~20GB dataset on a 15GB
# machine -> global OOM -> kernel killed the trainer -> tmux session died and
# best.pt was left truncated/corrupt.
#
# Fixes now in place: train.py uses cache="disk" + workers=4, and a 32GB swap
# file is enabled. This launcher adds: a detached run that survives a dropped
# tmux/ssh session, a persistent log, and OOM-priority protection so if memory
# ever gets tight the kernel kills a background service instead of training.
#
# Usage:
#   tmux new -s cumi_training        # start a SHELL first (not the command)
#   ./run_training.sh                # then run this inside it
#   tail -f train_*.log              # watch progress; Ctrl-b d to detach safely

set -euo pipefail
cd "$(dirname "$0")"

VENV_PY="./venv/bin/python"
LOG="train_$(date +%F_%H%M%S).log"

echo "Launching training -> $LOG"
# oom_score_adj=-500 makes the kernel prefer to kill other processes first.
nohup bash -c "echo -500 > /proc/self/oom_score_adj 2>/dev/null; exec $VENV_PY train.py" \
  > "$LOG" 2>&1 &

PID=$!
echo "PID=$PID   (survives session close)"
echo "Watch:  tail -f $LOG"
echo "Stop:   kill $PID"
