#!/bin/sh

DATASET_NAME=${DATASET_NAME:-'Dataset-Muaz'}
FEAT=${FEAT:-'pcode_raw'}
DBDIR=${DBDIR:-'dbs'}
OUTDIR=${OUTDIR:-'inputs/pcode'}

# Function to check and process each split
process_split() {
    SPLIT=$1
    SPLIT_DIR="$DBDIR/$DATASET_NAME/features/$SPLIT"
    FEAT_FILE="$SPLIT_DIR/${FEAT}_${DATASET_NAME}_$SPLIT"

    if [ -d "$SPLIT_DIR" ]; then
        echo "Processing ${DATASET_NAME}_$SPLIT"
        python preprocess/preprocessing_pcode.py \
            --freq-mode -f pkl -s ${DATASET_NAME}_$SPLIT \
            -i "$FEAT_FILE" \
            -o "$OUTDIR"
    else
        echo "Skipping ${DATASET_NAME}_$SPLIT: folder not found ($SPLIT_DIR)"
    fi
}

process_split "training"
process_split "validation"
process_split "testing"

