#!/bin/bash

VERSION=$1
TYPE=$2
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

# Set outputs environment variables
{
  echo "RELEASE_VERSION=$VERSION"
  echo "RELEASE_MAJOR_VERSION=$MAJOR"
  echo "RELEASE_MINOR_VERSION=$MINOR"
  echo "RELEASE_PATCH_VERSION=$PATCH"
  echo "RELEASE_TYPE=$TYPE"
} >> outputs.env
