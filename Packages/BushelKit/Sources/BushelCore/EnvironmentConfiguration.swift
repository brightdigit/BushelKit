//
// EnvironmentConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct EnvironmentConfiguration {
  public static let shared: EnvironmentConfiguration = .init()

  public let disableAssertionFailureForError: Bool

  init(environment: [String: String] = ProcessInfo.processInfo.environment) {
    self.disableAssertionFailureForError =
      environment["DISABLE_ASSERTION_FAILURE_FOR_ERROR"].flatMap(Bool.init) == true
  }
}
