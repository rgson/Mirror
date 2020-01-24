#!/bin/sh
set -e

upstream_repo='git@github.com:vis2k/Mirror.git'

# Read the upstream repo
git remote add upstream "$upstream_repo" >/dev/null 2>&1 || true
git fetch upstream

# Find the latest version
latest=$(git tag --list 'v*' | sort -Vr | head -n1)
if git rev-parse "upm/$latest" >/dev/null 2>&1; then
	echo "Already on newest version ($latest)"
	exit 0
fi

# Import the new version
rm -rf Mirror
mkdir Mirror
git archive "$latest" Assets/Mirror | tar --strip-components=2 -C Mirror -x
git archive "$latest" LICENSE | tar -C Mirror -x

# Generate package.json
cat > Mirror/package.json <<JSON
{
	"name": "com.vis2k.mirror",
	"displayName": "Mirror",
	"version": "${latest#v}",
	"unity": "2019.1",
	"description": "Mirror is a high level Networking API for Unity, supporting different low level Transports.",
	"author": "vis2k",
	"repository": {
		"type":"git",
		"url":"https://github.com/rgson/Mirror-UPM.git"
	},
	"samples":[
JSON
first=yes
for example_d in Mirror/Examples/*/; do
	if [ $first = 'no' ]; then echo '		,' >> Mirror/package.json; fi
	first=no
	example=$(basename "$example_d")
	cat >> Mirror/package.json <<JSON
		{
			"displayName": "$example",
			"description": "$example",
			"path": "Examples/$example"
		}
JSON
done
cat >> Mirror/package.json <<JSON
	]
}
JSON

# Generate Unity .meta files
cat > Mirror/package.json.meta <<META
fileFormatVersion: 2
guid: 63564e7531f695e388812dd877312d1a
TextScriptImporter:
  externalObjects: {}
  userData:
  assetBundleName:
  assetBundleVariant:
META
cat > Mirror/LICENSE.meta <<META
fileFormatVersion: 2
guid: 0ce294661c27df278a7d54386ca6150a
DefaultImporter:
  externalObjects: {}
  userData:
  assetBundleName:
  assetBundleVariant:
META

# Commit the new version
git add Mirror
git commit -m "Version $latest"

git branch -D upm >/dev/null 2>&1 || true
git subtree split -P Mirror -b upm

git tag "upm/$latest" upm

if [ "$1" = 'push' ]; then
	git push origin master:master
	git push -f origin upm:upm
	git push origin upm/$latest
fi
