//
// Bundle.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public extension Bundle {
  struct MissingIdentifierError: Error {
    private init() {}
    // swiftlint:disable:next strict_fileprivate
    fileprivate static let shared: Error = MissingIdentifierError()
  }

  func clearUserDefaults() throws {
    guard let domainName = self.bundleIdentifier else {
      throw MissingIdentifierError.shared
    }
    UserDefaults.standard.removePersistentDomain(forName: domainName)
  }
}
