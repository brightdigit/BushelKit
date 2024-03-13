//
// SpdevtoolsApps.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SpdevtoolsApps

public struct SpdevtoolsApps: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case spinstrumentsApp = "spinstruments_app"
    case spxcodeApp = "spxcode_app"
  }

  public let spinstrumentsApp: String
  public let spxcodeApp: String

  public init(spinstrumentsApp: String, spxcodeApp: String) {
    self.spinstrumentsApp = spinstrumentsApp
    self.spxcodeApp = spxcodeApp
  }
}
