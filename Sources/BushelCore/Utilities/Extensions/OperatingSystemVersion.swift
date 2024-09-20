//
//  OperatingSystemVersion.swift
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

public import Foundation

#if canImport(FoundationNetworking)
  extension OperatingSystemVersion: @unchecked Sendable {}
#endif
extension OperatingSystemVersion {
  private static let codeNames: [Int: String] = [
    11: "Big Sur",
    12: "Monterey",
    13: "Ventura",
    14: "Sonoma",
    15: "Sequoia"
  ]

  private static let minimumVirtualizationMajorVersion = 12

  public var macOSReleaseName: String? {
    Self.macOSReleaseName(majorVersion: majorVersion)
  }

  public static func macOSReleaseName(majorVersion: Int) -> String? {
    codeNames[majorVersion]
  }

  public static func availableMajorVersions(onlyVirtualizationSupported: Bool) -> any Collection<Int> {
    guard onlyVirtualizationSupported else {
      return codeNames.keys
    }
    return codeNames.keys.filter { $0 >= minimumVirtualizationMajorVersion }
  }
}
