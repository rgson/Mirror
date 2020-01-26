#!/bin/sh
set -e

for b in master upm
do
	git push origin $b:$b
done

git tag --list 'upm/v*' | xargs git push origin
