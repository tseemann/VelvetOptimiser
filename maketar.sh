#!/bin/bash
echo Producing tarball for velvet optimizer..
CURRENTDIR=$(pwd)
echo Current directory $CURRENTDIR
VERSION=$(grep "my \$OptVersion" VelvetOptimiser.pl | sed "s/my \$OptVersion = \"//" | sed "s/\";//")

echo Version = $VERSION
rm -r /tmp/VelvetOptimiser-$VERSION*
mkdir /tmp/VelvetOptimiser-$VERSION
cp -r VelvetOptimiser.pl README VelvetOpt /tmp/VelvetOptimiser-$VERSION
cd /tmp
tar -zcvf VelvetOptimiser-$VERSION.tar.gz VelvetOptimiser-$VERSION
cp VelvetOptimiser-$VERSION.tar.gz $CURRENTDIR
rm -r /tmp/VelvetOptimiser-$VERSION*
cd $CURRENTDIR
