# [vis2k/Mirror] for the Unity Package Manager

The Unity Package Manager is in many ways a more convenient alternative to the
Unity Asset Store for dependency management. Unfortunately, the maintainer of
[vis2k/Mirror] has [decided against UPM support][vis2k-reason] to drive more
traffic to the Asset Store.

This repository adds UPM support to the upstream version of Mirror. It is not a
fork of Mirror, but rather an otherwise unmodified repackaging of the upstream
to support installation through the Unity Package Manager.

Inspired by this [issue][vis2k/Mirror#891] and [pull request][vis2k/Mirror#892].


## Installation

To install the package, add the following line to your `Packages/manifest.json`
file, under `dependencies`:
```json
"com.vis2k.mirror": "https://github.com/rgson/Mirror-UPM.git#upm",
```

Alternatively, install and use the [UpmGitExtension] to add it from Unity's
Package Manager GUI.


<!-- Refs -->
[vis2k/Mirror]: https://github.com/vis2k/Mirror
[vis2k/Mirror#891]: https://github.com/vis2k/Mirror/issues/891
[vis2k/Mirror#892]: https://github.com/vis2k/Mirror/pull/892
[vis2k-reason]: https://github.com/vis2k/Mirror/pull/892#issuecomment-544277802
[UpmGitExtension]: https://github.com/mob-sakai/UpmGitExtension
