//
// MockInstallerImage.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMachine
import BushelMachineWax
import Foundation

internal struct MockInstallerImage: InstallerImage, Equatable {
  let libraryID: BushelCore.LibraryIdentifier?

  let imageID: UUID

  let metadata: Metadata
  static func random(
    withReleaseCount releaseCount: Int,
    startingAt firstMajorVersion: Int,
    withAverageImageCount averageImageCountPerRelease: Int,
    includingCustomReleaseCount customReleaseCount: Int
  ) -> [Int: [MockInstallerImage]] {
    let lowerBound = firstMajorVersion
    let upperBound = firstMajorVersion + releaseCount - 1
    let majorVersionRange = (lowerBound ... upperBound).expanded(by: customReleaseCount)
    let upperBoundReleaseCount = 2 * averageImageCountPerRelease - 1
    var dictionary: [Int: [MockInstallerImage]] = .init()
    for majorVersion in majorVersionRange {
      let osVersionsAll = (0 ..< upperBoundReleaseCount).map { _ in
        OperatingSystemVersion(
          majorVersion: majorVersion,
          minorVersion: .random(in: 0 ... 9),
          patchVersion: .random(in: 0 ... 9)
        )
      }
      let osVersionsSet = Set(osVersionsAll)
      let versionCount: Int = .random(in: 1 ..< osVersionsSet.count)
      let osVersions = osVersionsSet.shuffled()[0 ..< versionCount]
      let versions = osVersions.map {
        MockInstallerImage(libraryID: nil, imageID: .init(), metadata: .init(operatingSystem: $0))
      }
      dictionary[majorVersion] = versions
    }
    return dictionary
  }

  func getURL() async throws -> URL {
    assertionFailure("Shouldn't be called.")
    return URL.randomFile()
  }
}
