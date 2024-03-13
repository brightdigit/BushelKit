//
// SpairportSoftwareInformation.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SpairportSoftwareInformation

public struct SpairportSoftwareInformation: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case spairportCorewlanVersion = "spairport_corewlan_version"
    case spairportCorewlankitVersion = "spairport_corewlankit_version"
    case spairportDiagnosticsVersion = "spairport_diagnostics_version"
    case spairportExtraVersion = "spairport_extra_version"
    case spairportFamilyVersion = "spairport_family_version"
    case spairportProfilerVersion = "spairport_profiler_version"
    case spairportUtilityVersion = "spairport_utility_version"
  }

  public let spairportCorewlanVersion: String
  public let spairportCorewlankitVersion: String
  public let spairportDiagnosticsVersion: String
  public let spairportExtraVersion: String
  public let spairportFamilyVersion: String
  public let spairportProfilerVersion: String
  public let spairportUtilityVersion: String

  // swiftlint:disable:next line_length
  public init(spairportCorewlanVersion: String, spairportCorewlankitVersion: String, spairportDiagnosticsVersion: String, spairportExtraVersion: String, spairportFamilyVersion: String, spairportProfilerVersion: String, spairportUtilityVersion: String) {
    self.spairportCorewlanVersion = spairportCorewlanVersion
    self.spairportCorewlankitVersion = spairportCorewlankitVersion
    self.spairportDiagnosticsVersion = spairportDiagnosticsVersion
    self.spairportExtraVersion = spairportExtraVersion
    self.spairportFamilyVersion = spairportFamilyVersion
    self.spairportProfilerVersion = spairportProfilerVersion
    self.spairportUtilityVersion = spairportUtilityVersion
  }
}
