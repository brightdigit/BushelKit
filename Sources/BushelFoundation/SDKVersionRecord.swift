//
//  SDKVersionRecord.swift
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

/// Represents a platform SDK build (iOS, macOS, tvOS, visionOS, watchOS) shipped with Xcode.
///
/// One record exists per platform + SDK build, no matter how many Xcode releases bundled it.
/// Clients that manage simulator runtimes can use these records to tell whether an installed
/// beta runtime has a final release (``supersededBy``), and which Xcode it belongs to
/// (``xcodeVersion``).
///
/// - Note: SDK build numbers do not always equal simulator runtime build numbers,
///   so clients should match runtimes on ``platform`` + ``version`` + ``isPrerelease``
///   and treat a ``buildNumber`` match as a bonus.
public struct SDKVersionRecord: Codable, Sendable, Equatable {
  /// Apple platforms that ship SDKs with Xcode.
  public enum Platform: String, Codable, Sendable, CaseIterable {
    /// iOS and iPadOS.
    case iOS
    /// macOS.
    case macOS
    /// tvOS.
    case tvOS
    /// visionOS.
    case visionOS
    /// watchOS.
    case watchOS
  }

  /// The SDK's platform
  public var platform: Platform

  /// Marketing version of the SDK (e.g., "27.0")
  public var version: String

  /// SDK build number (e.g., "24A340" or "24A5318c")
  public var buildNumber: String

  /// Beta/RC indicator: `true` when every Xcode that bundled this SDK build was a beta or RC
  public var isPrerelease: Bool

  /// Prerelease stage from the first Xcode that bundled it (e.g., "Beta 5", "RC 1");
  /// `nil` for final releases
  public var prereleaseLabel: String?

  /// Release date of the first Xcode that bundled this SDK build
  public var releaseDate: Date

  /// Reference to the Xcode that introduced this SDK build (XcodeVersion recordName);
  /// the first final release when there is one, otherwise the first prerelease
  public var xcodeVersion: String?

  /// For prereleases: reference to the final SDK that replaces it (SDKVersion recordName)
  public var supersededBy: String?

  /// For prereleases: release date of the record in ``supersededBy``
  public var supersededAt: Date?

  /// CloudKit record name based on platform and build number (e.g., "SDKVersion-iOS-24A340")
  public var recordName: String {
    "SDKVersion-\(platform.rawValue)-\(buildNumber)"
  }

  /// Creates a new SDK version record.
  ///
  /// - Parameters:
  ///   - platform: The SDK's platform.
  ///   - version: The marketing version of the SDK.
  ///   - buildNumber: The SDK build number.
  ///   - isPrerelease: Whether every Xcode that bundled this build was a beta or RC.
  ///   - prereleaseLabel: The prerelease stage, such as "Beta 5"; `nil` for final releases.
  ///   - releaseDate: The release date of the first Xcode that bundled this build.
  ///   - xcodeVersion: The record name of the Xcode that introduced this build.
  ///   - supersededBy: The record name of the final SDK that replaces this prerelease.
  ///   - supersededAt: The release date of the record in `supersededBy`.
  public init(
    platform: Platform,
    version: String,
    buildNumber: String,
    isPrerelease: Bool,
    prereleaseLabel: String? = nil,
    releaseDate: Date,
    xcodeVersion: String? = nil,
    supersededBy: String? = nil,
    supersededAt: Date? = nil
  ) {
    self.platform = platform
    self.version = version
    self.buildNumber = buildNumber
    self.isPrerelease = isPrerelease
    self.prereleaseLabel = prereleaseLabel
    self.releaseDate = releaseDate
    self.xcodeVersion = xcodeVersion
    self.supersededBy = supersededBy
    self.supersededAt = supersededAt
  }
}
