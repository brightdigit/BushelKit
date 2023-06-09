//
// LoggerCategory.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

@available(*, deprecated, message: "Move to another package.")
public enum LoggerCategory: String, CaseIterable {
  case document
  case machines
  case imageManagers
  case reactive
  // swiftlint:disable:next identifier_name
  case ui
  case userDefaults
}
