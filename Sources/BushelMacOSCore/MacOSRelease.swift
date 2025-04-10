//
//  MacOSRelease.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

public import BushelFoundation
internal import Foundation
internal import OSVer

public struct MacOSRelease: InstallerRelease {
  public let majorVersion: Int
  public let versionName: String
  public let releaseName: String
  public let imageName: String
  public var id: Int {
    majorVersion
  }

  public init?(majorVersion: Int) {
    guard let releaseName = OSVer.macOSReleaseName(majorVersion: majorVersion)
    else {
      assertionFailure("Missing Metadata for macOS \(majorVersion).")
      return nil
    }

    guard let imageName = MacOSVirtualization.imageName(forMajorVersion: majorVersion) else {
      assertionFailure("Missing Image for macOS \(majorVersion).")
      return nil
    }

    let versionName = "\(MacOSVirtualization.shortName) \(majorVersion)"

    self.init(
      majorVersion: majorVersion,
      releaseName: releaseName,
      versionName: versionName,
      imageName: imageName
    )
  }

  private init(majorVersion: Int, releaseName: String, versionName: String, imageName: String) {
    self.majorVersion = majorVersion
    self.releaseName = releaseName
    self.versionName = versionName
    self.imageName = imageName
  }
}
