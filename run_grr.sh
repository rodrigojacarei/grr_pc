#!/usr/bin/env bash
set -euo pipefail
ulimit -c 0
DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
export GRR_GAME_DIR="${GRR_GAME_DIR:-${GRHD_GAME_DIR:-${TLG_GAME_DIR:-$HOME/grhd/CUSA01130}}}"
export TLG_GAME_DIR="$GRR_GAME_DIR"
# Gravity Rush: geometry shaders emit clean base triangle mesh while bypassing broken outline strips
export GRR_GS_PASSTHROUGH="${GRR_GS_PASSTHROUGH:-1}"
export TLG_GS_PASSTHROUGH="$GRR_GS_PASSTHROUGH"

# Drop geometry shader draws (only if troubleshooting; 0 allows Kat and characters to render)
export GRR_SKIP_GEOMETRY="${GRR_SKIP_GEOMETRY:-0}"
export GRR_SKIP_ADJACENCY="${GRR_SKIP_ADJACENCY:-1}"
export TLG_SKIP_GEOMETRY="$GRR_SKIP_GEOMETRY"
export TLG_SKIP_ADJACENCY="$GRR_SKIP_ADJACENCY"

# Buffer readbacks: 2 (Precise) ensures CPU-GPU buffer synchronization (AsyncMap) for skinning/transforms
export GRR_READBACKS="${GRR_READBACKS:-2}"
export TLG_READBACKS="$GRR_READBACKS"

# Pipeline binaries: 0 prevents crashes on NVIDIA proprietary drivers
export GRR_PIPELINE_BINARIES="${GRR_PIPELINE_BINARIES:-0}"
export TLG_PIPELINE_BINARIES="$GRR_PIPELINE_BINARIES"

# BP08 (driver pipeline cache blob): 0 prevents corrupted texture pipelines across sessions
export GRR_BP08="${GRR_BP08:-0}"
export TLG_BP08="$GRR_BP08"

# Warmup stages only: 1 preloads SPIR-V without constructing incomplete speculative pipelines
export GRR_WARMUP_STAGES_ONLY="${GRR_WARMUP_STAGES_ONLY:-1}"
export TLG_WARMUP_STAGES_ONLY="$GRR_WARMUP_STAGES_ONLY"
cd "$DIR/port"
exec bash run.sh "$@"
