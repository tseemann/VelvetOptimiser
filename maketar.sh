#!/bin/bash

DEST=/tmp
echo "Producing distributable .tar.gz for VelvetOptimizer in $DEST ..."

CURRENTDIR=$(pwd)
echo Current directory $CURRENTDIR
#VERSION=$(grep "my \$OptVersion" VelvetOptimiser.pl | sed "s/my \$OptVersion = \"//" | sed "s/\";//")

VERSION=$(./VelvetOptimiser.pl --version 2> /dev/null | sed 's/^.* //')
echo "Determined version: $VERSION"
if [ "$VERSION" == "" ]; then
  echo "ERROR: could not get version!"
  exit -1
fi

TARDIR="$DEST/VelvetOptimiser-$VERSION"
if [ -d "$TARDIR" ]; then
  rm -r $TARDIR
fi
if [ -f "$TARDIR.tar.gz" ]; then
  rm "$TARDIR.tar.gz"
fi

echo "Copying files..."
mkdir $TARDIR
cp -v -r VelvetOptimiser.pl LICENSE README VelvetOpt $TARDIR
cd $DEST

echo "Tarring..."
tar -zcvf VelvetOptimiser-$VERSION.tar.gz VelvetOptimiser-$VERSION
rm -r $TARDIR

echo "Checking..."
tar ztf "$TARDIR.tar.gz"

cd $CURRENTDIR
echo "Archive is here: $TARDIR.tar.gz"
ls -lsa "$TARDIR.tar.gz"

