//
//  SimulatorRuntimeRecord.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2026 BrightDigit.
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

/// Represents a simulator runtime build (iOS, tvOS, visionOS, watchOS) from Apple's
/// simulator index (`index2.dvtdownloadableindex`).
///
/// One record exists per platform + runtime build. A runtime's build often differs from
/// the SDK build it ships with (iOS 27.2 RC's runtime is `24B114`, its SDK `24B113`), and
/// device-specific runtimes such as iPhone Duo's (`24B91016s`) have no SDK record at all,
/// so clients that manage installed runtimes match on ``buildNumber`` here first.
///
/// ``releaseLabel`` comes from the index's runtime name ("iOS 27.2 Release Candidate
/// Simulator Runtime"), never from the build number. The index has no release dates.
public struct SimulatorRuntimeRecord: Codable, Sendable, Hashable {
  /// The runtime's platform. Runtimes never have `macOS`.
  public typealias Platform = SDKVersionRecord.Platform

  /// The runtime's platform.
  public var platform: Platform

  /// Marketing version of the runtime (e.g., "27.2" or "26.4.1")
  public var version: String

  /// Runtime build number (e.g., "24B114" or "24B91016s")
  public var buildNumber: String

  /// Beta N, RC N or final, as Apple's index names the runtime
  public var releaseLabel: ReleaseLabel

  /// SDK builds the index maps to this runtime (`sdkToSimulatorMappings`), sorted.
  /// Empty when the index has no mapping. One SDK can map to several runtimes.
  public var sdkBuildNumbers: [String]

  /// Whether the runtime is a beta or release candidate.
  public var isPrerelease: Bool {
    releaseLabel.isPrerelease
  }

  /// CloudKit record name based on platform and build number
  /// (e.g., "SimulatorRuntime-iOS-24B114")
  public var recordName: String {
    "SimulatorRuntime-\(platform.rawValue)-\(buildNumber)"
  }

  /// Creates a new simulator runtime record.
  ///
  /// - Parameters:
  ///   - platform: The runtime's platform.
  ///   - version: The marketing version of the runtime.
  ///   - buildNumber: The runtime build number.
  ///   - releaseLabel: Beta N, RC N or final.
  ///   - sdkBuildNumbers: The SDK builds that map to this runtime.
  public init(
    platform: Platform,
    version: String,
    buildNumber: String,
    releaseLabel: ReleaseLabel,
    sdkBuildNumbers: [String] = []
  ) {
    self.platform = platform
    self.version = version
    self.buildNumber = buildNumber
    self.releaseLabel = releaseLabel
    self.sdkBuildNumbers = sdkBuildNumbers
  }
}
