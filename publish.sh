#!/bin/sh
set -e

git push origin upm:upm
git tag --list 'upm/v*' | xargs git push origin
