#!/bin/sh

#get latest tag
latest=$(git describe --abbrev=0 --tags)


echo "Starting alpine git build script"
