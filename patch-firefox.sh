#!/bin/bash -e

if [[ -z $MOZILLA_HOME ]]; then
    echo "Set MOZILLA_HOME first"
    exit 1
fi

if [[ -f $MOZILLA_HOME/omni-orig.ja ]]; then
    echo "Already patched?"
    exit 1
fi

cp $MOZILLA_HOME/omni.ja $MOZILLA_HOME/omni-orig.ja

TEMPDIR=$(mktemp -d)
if [[ ! -d $TEMPDIR ]]; then
   echo "Couldn't create tempdir"
   exit 1
fi

unzip -q -d $TEMPDIR $MOZILLA_HOME/omni.ja || true

if [[ ! -f $TEMPDIR/modules/AppConstants.jsm ]]; then
    rm -r $TEMPDIR
    echo "Unzip was unsuccessful"
    exit 1
fi

SIGNLINE=$(grep -n "MOZ_REQUIRE_SIGNING:" $TEMPDIR/modules/AppConstants.jsm | cut -d: -f 1)

CURRENT_CONST=$(tail -n +$(($SIGNLINE + 2)) $TEMPDIR/modules/AppConstants.jsm | head -n1)

if [[ $CURRENT_CONST != "  true," ]]; then
    rm -r $TEMPDIR
    echo "Didn't find correct data in existing file"
    exit 1
fi

sed -i -e "$((SIGNLINE + 2))s/true/false/" $TEMPDIR/modules/AppConstants.jsm

rm $MOZILLA_HOME/omni.ja
cd $TEMPDIR
zip -qr9XD $MOZILLA_HOME/omni.ja *
cd -

rm -r $TEMPDIR
echo Done
