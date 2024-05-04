//
// MockReleaseCollectionMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore

struct MockReleaseCollectionMetadata: ReleaseCollectionMetadata {
  typealias InstallerReleaseType = MockInstallerRelease

  let releases: [MockInstallerRelease]

  let customVersionsAllowed: Bool

  let prefix: String
}

extension MockReleaseCollectionMetadata {
  static func random(
    startingAt firstMajorVersion: Int,
    count: Int,
    customVersionsAllowed: Bool,
    prefix: String? = nil
  ) -> any ReleaseCollectionMetadata {
    let releases = (0 ..< count).map { offset in
      MockInstallerRelease(
        versionName: .randomLowerCaseAlphaNumberic(),
        releaseName: .randomLowerCaseAlphaNumberic(),
        imageName: .randomLowerCaseAlphaNumberic(),
        majorVersion: firstMajorVersion + offset
      )
    }
    return MockReleaseCollectionMetadata(
      releases: releases,
      customVersionsAllowed: customVersionsAllowed,
      prefix: prefix ?? .randomLowerCaseAlphaNumberic()
    )
  }
}
