# Contributing

- When contributing to this repository, please first discuss the changes and the motive behind it, with our team members.

- Only changes which apply to most of the project would be accepted, as we would like to keep it as general as possible.

## Pull Request Process

1. Ensure the NetworkEngine is working fine by integrating it to a demo project by locally integrating it.
2. Update the README.md with details of changes and try to explain the changes in the code documentation as much as possible

## Release process

When you develop for this NetworkEngine and the PR gets merged,
a new binary needs to be released on the [public repo][network-engine-xc] that hosts the XCFramework binaries.

Below are the commands you can use for building the binaries and updating them in the Package.swift.
Note: Do not forget the match the releases with the tags here and on the public repo (so we can track the binary releases)

### Commands to create the archives
```bash
xcodebuild archive \
-project NetworkEngine.xcodeproj \
-scheme NetworkEngine \
-destination "generic/platform=iOS" \
-archivePath "archives/NetworkEngine-iOS"
```

```bash
xcodebuild archive \
-project NetworkEngine.xcodeproj \
-scheme NetworkEngine \
-destination "generic/platform=iOS Simulator" \
-archivePath "archives/NetworkEngine-iOS-Simulator"
```

```bash
xcodebuild archive \
-project NetworkEngine.xcodeproj \
-scheme NetworkEngine \
-destination "generic/platform=watchOS" \
-archivePath "archives/NetworkEngine-watchOS"
```

```bash
xcodebuild archive \
-project NetworkEngine.xcodeproj \
-scheme NetworkEngine \
-destination "generic/platform=watchOS Simulator" \
-archivePath "archives/NetworkEngine-watchOS-Simulator"
```

### Command to create XCFramework
```bash
xcodebuild -create-xcframework \
-archive archives/NetworkEngine-iOS.xcarchive -framework NetworkEngine.framework \
-archive archives/NetworkEngine-iOS-Simulator.xcarchive -framework NetworkEngine.framework \
-archive archives/NetworkEngine-watchOS.xcarchive -framework NetworkEngine.framework \
-archive archives/NetworkEngine-watchOS-Simulator.xcarchive -framework NetworkEngine.framework \
-output xcframeworks/NetworkEngine.xcframework
```
Convert the `NetworkEngine.xcframework` to a zip

### Command to create checksum
```bash
swift package compute-checksum NetworkEngine.xcframework.zip
```

- Update the checksum and url in [Package.swift][package-swift] (do not forget to pre-update the [README.md][readme-md] for version changes),
- Create a PR and once the PR is merged,
- Push a tag with relevant version tag (the one you mentioned in the Package.swift's url),
- Create a release on [public repo][network-engine-xc], upload the zip (push that tag on this private repo as well).

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)

   [network-engine-xc]: <https://github.com/mobile-simformsolutions/NetworkEngineXC>
   [package-swift]: <https://github.com/mobile-simformsolutions/NetworkEngineXC/blob/master/Package.swift>
   [readme-md]: <https://github.com/mobile-simformsolutions/NetworkEngineXC/blob/master/README.md>
