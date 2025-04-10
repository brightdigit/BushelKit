//
//  SpairportSoftwareInformation.swift
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

internal import Foundation

/// Represents the software information for the Spairport system.
public struct SpairportSoftwareInformation: Codable, Equatable, Sendable {
  /// The coding keys for the Spairport software information.
  public enum CodingKeys: String, CodingKey {
    case spairportCorewlanVersion = "spairport_corewlan_version"
    case spairportCorewlankitVersion = "spairport_corewlankit_version"
    case spairportDiagnosticsVersion = "spairport_diagnostics_version"
    case spairportExtraVersion = "spairport_extra_version"
    case spairportFamilyVersion = "spairport_family_version"
    case spairportProfilerVersion = "spairport_profiler_version"
    case spairportUtilityVersion = "spairport_utility_version"
  }

  /// The version of the Spairport Corewlan component.
  public let spairportCorewlanVersion: String
  /// The version of the Spairport Corewlankit component.
  public let spairportCorewlankitVersion: String
  /// The version of the Spairport Diagnostics component.
  public let spairportDiagnosticsVersion: String
  /// The version of the Spairport Extra component.
  public let spairportExtraVersion: String
  /// The version of the Spairport Family component.
  public let spairportFamilyVersion: String
  /// The version of the Spairport Profiler component.
  public let spairportProfilerVersion: String
  /// The version of the Spairport Utility component.
  public let spairportUtilityVersion: String

  /// Initializes a new instance of the `SpairportSoftwareInformation` struct.
  /// - Parameters:
  ///   - spairportCorewlanVersion: The version of the Spairport Corewlan component.
  ///   - spairportCorewlankitVersion: The version of the Spairport Corewlankit component.
  ///   - spairportDiagnosticsVersion: The version of the Spairport Diagnostics component.
  ///   - spairportExtraVersion: The version of the Spairport Extra component.
  ///   - spairportFamilyVersion: The version of the Spairport Family component.
  ///   - spairportProfilerVersion: The version of the Spairport Profiler component.
  ///   - spairportUtilityVersion: The version of the Spairport Utility component.
  public init(
    spairportCorewlanVersion: String,
    spairportCorewlankitVersion: String,
    spairportDiagnosticsVersion: String,
    spairportExtraVersion: String,
    spairportFamilyVersion: String,
    spairportProfilerVersion: String,
    spairportUtilityVersion: String
  ) {
    self.spairportCorewlanVersion = spairportCorewlanVersion
    self.spairportCorewlankitVersion = spairportCorewlankitVersion
    self.spairportDiagnosticsVersion = spairportDiagnosticsVersion
    self.spairportExtraVersion = spairportExtraVersion
    self.spairportFamilyVersion = spairportFamilyVersion
    self.spairportProfilerVersion = spairportProfilerVersion
    self.spairportUtilityVersion = spairportUtilityVersion
  }
}
