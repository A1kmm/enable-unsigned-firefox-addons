#!/bin/bash -e

if [[ -z $MOZILLA_HOME ]]; then
    echo "Set MOZILLA_HOME first"
    exit 1
fi

if [[ ! -f $MOZILLA_HOME/omni-orig.ja ]]; then
    echo "Not already patched"
    exit 1
fi

cp $MOZILLA_HOME/omni-orig.ja $MOZILLA_HOME/omni.ja
rm $MOZILLA_HOME/omni-orig.ja
