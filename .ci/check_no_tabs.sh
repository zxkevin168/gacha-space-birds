#!/bin/sh
# Fails if any .gd file contains a tab character
if grep -P '\t' $(find . -name '*.gd'); then
  echo 'Error: Tab character found in .gd files. Use 4 spaces for indentation.'
  exit 1
fi
exit 0