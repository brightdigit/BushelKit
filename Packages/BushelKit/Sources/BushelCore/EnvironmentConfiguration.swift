//
// EnvironmentConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct EnvironmentConfiguration: CustomReflectable {
  public enum Key: String {
    case disableAssertionFailureForError = "DISABLE_ASSERTION_FAILURE_FOR_ERROR"
    case disallowDatabaseRebuild = "DISALLOW_DATABASE_REBUILD"
    case skipOnboarding = "SKIP_ONBOARDING"
    case resetApplication = "RESET_APPLICATION"
  }

  public static let shared: EnvironmentConfiguration = .init()

  @EnvironmentProperty(Key.disableAssertionFailureForError)
  public var disableAssertionFailureForError: Bool

  @EnvironmentProperty(Key.disallowDatabaseRebuild)
  public var disallowDatabaseRebuild: Bool

  @EnvironmentProperty(Key.skipOnboarding)
  public var skipOnboarding: Bool

  @EnvironmentProperty(Key.resetApplication)
  public var resetApplication: Bool

  public var customMirror: Mirror {
    Mirror(self, children: [
      "disableAssertionFailureForError": disableAssertionFailureForError,
      "disallowDatabaseRebuild": disallowDatabaseRebuild,
      "skipOnboarding": skipOnboarding,
      "resetApplication": resetApplication
    ])
  }

  internal init() {}
}
