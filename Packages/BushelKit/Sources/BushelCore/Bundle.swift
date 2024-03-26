//
// Bundle.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public extension Bundle {
  struct MissingIdentifierError: Error {
    private init() {}
    // swiftlint:disable:next strict_fileprivate
    fileprivate static let shared: any Error = MissingIdentifierError()
  }

  static let suiteName = "group.com.brightdigit.Bushel"

  func clearUserDefaults() throws {
    guard let domainName = self.bundleIdentifier else {
      throw MissingIdentifierError.shared
    }
    UserDefaults.standard.removePersistentDomain(forName: domainName)
  }
}
