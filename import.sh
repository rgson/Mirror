#!/bin/sh
set -e

upstream_repo='git@github.com:vis2k/Mirror.git'

# Read the upstream repo
git remote add upstream "$upstream_repo" >/dev/null 2>&1 || true
git fetch upstream

# Find the latest version
version="$1"
if [ -z "$1" ]; then
	version=$(git tag --list 'v*' | sort -Vr | head -n1)
fi

# Checkout the packaging branch
git checkout upm || git checkout --orphan upm

# Import the new version
rm -rf *
git archive "$version" Assets/Mirror | tar --strip-components=2 -x
git archive "$version" LICENSE | tar -x

# Generate package.json
cat > package.json <<JSON
{
	"name": "com.vis2k.mirror",
	"displayName": "Mirror",
	"version": "${version#v}",
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
for example_d in Examples/*/; do
	if [ $first = 'no' ]; then echo '		,' >> package.json; fi
	first=no
	example=$(basename "$example_d")
	cat >> package.json <<JSON
		{
			"displayName": "$example",
			"description": "$example",
			"path": "Examples/$example"
		}
JSON
done
cat >> package.json <<JSON
	]
}
JSON

# Generate Unity .meta files
guid_namespace='446a8562-bed1-443d-bb0d-d1193f90358b'
for f in \
	LICENSE \
	package.json \
;do
	guid=$(uuidgen --sha1 --namespace "$guid_namespace" --name "$f" | tr -d -)
	cat > "$f.meta" <<META
fileFormatVersion: 2
guid: $guid
TextScriptImporter:
  externalObjects: {}
  userData:
  assetBundleName:
  assetBundleVariant:
META
done

# Commit the new version
git add .
git commit -m "Version $version"

git tag "upm/$version" || true

git checkout master
