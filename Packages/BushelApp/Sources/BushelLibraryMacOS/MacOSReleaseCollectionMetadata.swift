//
// MacOSReleaseCollectionMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMacOSCore
import Foundation
import OperatingSystemVersion

#if canImport(Virtualization) && arch(arm64)

  internal struct MacOSReleaseCollectionMetadata: ReleaseCollectionMetadata {
    internal typealias InstallerReleaseType = MacOSRelease

    internal static let macosReleases: any ReleaseCollectionMetadata =
      MacOSReleaseCollectionMetadata(
        majorVersions: OperatingSystemVersion.availableMajorVersions(onlyVirtualizationSupported: true)
      )
    internal let releases: [MacOSRelease]
    internal let customVersionsAllowed: Bool
    internal let prefix: String

    private init(
      releases: [MacOSRelease],
      prefix: String = MacOSVirtualization.shortName,
      customVersionsAllowed: Bool = true
    ) {
      self.releases = releases
      self.prefix = prefix
      self.customVersionsAllowed = customVersionsAllowed
    }

    private init(majorVersions: any Collection<Int>, customVersionsAllowed: Bool = true) {
      let releases = majorVersions.compactMap(MacOSRelease.init(majorVersion:))
      assert(releases.count == majorVersions.count)
      self.init(releases: releases, customVersionsAllowed: customVersionsAllowed)
    }
  }
#endif
