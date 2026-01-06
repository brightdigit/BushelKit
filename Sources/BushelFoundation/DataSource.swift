//
//  DataSource.swift
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

public import Foundation

/// Represents known data sources for fetching VM-related data
public enum DataSource: String, Codable, Sendable, CaseIterable {
  // MARK: - Restore Image Sources

  /// AppleDB - Frequently updated restore images
  case appleDB = "appledb.dev"

  /// IPSW.me - Less frequent updates
  case ipswMe = "ipsw.me"

  /// MESU Apple - Apple's signing service
  case mesuApple = "mesu.apple.com"

  /// Mr. Macintosh - Manual updates
  case mrMacintosh = "mrmacintosh.com"

  /// The Apple Wiki - Deprecated, rarely updated
  case theAppleWiki = "theapplewiki.com"

  // MARK: - Version Sources

  /// Xcode Releases - Xcode version information
  case xcodeReleases = "xcodereleases.com"

  /// Swift Version - Swift compiler releases
  case swiftVersion = "swiftversion.net"

  // MARK: - Computed Properties

  /// Default minimum fetch interval for this source (in seconds)
  public var defaultInterval: TimeInterval {
    switch self {
    case .appleDB:
      return 6 * 3_600  // 6 hours
    case .ipswMe:
      return 12 * 3_600  // 12 hours
    case .mesuApple:
      return 1 * 3_600  // 1 hour
    case .mrMacintosh:
      return 12 * 3_600  // 12 hours
    case .theAppleWiki:
      return 24 * 3_600  // 24 hours
    case .xcodeReleases:
      return 12 * 3_600  // 12 hours
    case .swiftVersion:
      return 12 * 3_600  // 12 hours
    }
  }

  /// Environment variable key for overriding this source's fetch interval
  public var environmentKey: String {
    "BUSHEL_FETCH_INTERVAL_\(rawValue.uppercased().replacingOccurrences(of: ".", with: "_"))"
  }
}
