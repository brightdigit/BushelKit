//
// OperatingSystemCodeName.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import Foundation

public enum OperatingSystemCodeName: Int, CaseIterable {
  case bigSur = 11
  case monterey = 12
  case ventura = 13

  public init?(operatingSystemVersion: OperatingSystemVersion) {
    self.init(rawValue: operatingSystemVersion.majorVersion)
  }

  static let names: [OperatingSystemCodeName: String] = [
    .bigSur: "Big Sur",
    .monterey: "Monterey",
    .ventura: "Ventura"
  ]
  public var name: String {
    guard let name = Self.names[self] else {
      preconditionFailure()
    }
    return name
  }
}
