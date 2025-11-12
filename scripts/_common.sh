#!/bin/bash
# ==================================================
# 🔧 COMMON SCRIPT HELPERS
# ==================================================
# Shared functions and path resolution for all scripts
# Source this file at the top of scripts: source "$(dirname "$0")/_common.sh"

# Get script directory and calculate paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$SCRIPTS_ROOT/.." && pwd)"

# Export paths
export SCRIPT_DIR SCRIPTS_ROOT PROJECT_ROOT

# Source environment setup
source "$SCRIPTS_ROOT/core/setup_env.sh"

