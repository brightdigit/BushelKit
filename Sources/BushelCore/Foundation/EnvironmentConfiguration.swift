//
//  EnvironmentConfiguration.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

import Foundation

public struct EnvironmentConfiguration: CustomReflectable, Sendable {
  public enum Key: String {
    case disableAssertionFailureForError = "DISABLE_ASSERTION_FAILURE_FOR_ERROR"
    case disallowDatabaseRebuild = "DISALLOW_DATABASE_REBUILD"
    case onboardingOveride = "ONBOARDING_OVERRIDE"
    case resetApplication = "RESET_APPLICATION"
  }

  public static let shared: EnvironmentConfiguration = .init()

  @EnvironmentProperty(Key.disableAssertionFailureForError)
  public var disableAssertionFailureForError: Bool

  @EnvironmentProperty(Key.disallowDatabaseRebuild)
  public var disallowDatabaseRebuild: Bool

  @EnvironmentProperty(Key.onboardingOveride)
  public var onboardingOveride: OnboardingOverrideOption

  @EnvironmentProperty(Key.resetApplication)
  public var resetApplication: Bool

  public var customMirror: Mirror {
    Mirror(
      self,
      children: [
        "disableAssertionFailureForError": disableAssertionFailureForError,
        "disallowDatabaseRebuild": disallowDatabaseRebuild,
        "onboardingOveride": onboardingOveride,
        "resetApplication": resetApplication
      ]
    )
  }

  internal init() {}
}
