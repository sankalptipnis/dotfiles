#!/usr/bin/env bash

shopt -s nullglob

BIN_NAME=$(basename "$0")

function usage {
    echo ""
    echo "Usage:"
    echo "$BIN_NAME env_dir"
    echo ""
    echo "This utility creates conda environments as defined"
    echo "by the files in the input directory. "
    echo ""
    exit 1
}

ENV_DIR="$1"

[[ -z "$ENV_DIR" ]] && echo "Environment directory not specified!" && usage
[[ ! -d "$ENV_DIR" ]] && echo "The environment directory does not exist!" && usage

for FILE in "$ENV_DIR"/*; do
    echo "--------------------------------------------------------------------------------------------------"
    echo "Attempting to create a conda env from file: $FILE"
    echo "--------------------------------------------------------------------------------------------------"

    mamba env create -f "$FILE"
    
    echo ""						 
done