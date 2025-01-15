//
//  MockInstallerImage.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import BushelFoundation
import BushelMachine
import BushelMachineWax
import Foundation
import OSVer

internal struct MockInstallerImage: InstallerImage, Equatable {
  internal let libraryID: LibraryIdentifier?

  internal let imageID: UUID

  internal let metadata: Metadata
  internal static func random(
    withReleaseCount releaseCount: Int,
    startingAt firstMajorVersion: Int,
    withAverageImageCount averageImageCountPerRelease: Int,
    includingCustomReleaseCount customReleaseCount: Int
  ) -> [Int: [MockInstallerImage]] {
    let lowerBound = firstMajorVersion
    let upperBound = firstMajorVersion + releaseCount - 1
    let majorVersionRange = (lowerBound...upperBound).expanded(by: customReleaseCount)
    let upperBoundReleaseCount = 2 * averageImageCountPerRelease - 1
    var dictionary: [Int: [MockInstallerImage]] = .init()
    for majorVersion in majorVersionRange {
      let osVersionsAll = (0..<upperBoundReleaseCount).map { _ in
        OSVer(
          majorVersion: majorVersion,
          minorVersion: .random(in: 0...9),
          patchVersion: .random(in: 0...9)
        )
      }
      let osVersionsSet = Set(osVersionsAll)
      let versionCount: Int = .random(in: 1..<osVersionsSet.count)
      let osVersions = osVersionsSet.shuffled()[0..<versionCount]
      let versions = osVersions.map {
        MockInstallerImage(libraryID: nil, imageID: .init(), metadata: .init(operatingSystem: $0))
      }
      dictionary[majorVersion] = versions
    }
    return dictionary
  }

  internal func getURL() async throws -> URL {
    assertionFailure("Shouldn't be called.")
    return URL.randomFile()
  }
}
