//
//  EnvironmentConfiguration.swift
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

public import BushelUtilities
internal import Foundation

/// Represents the environment configuration for the application.
/// This type conforms to `CustomReflectable` and `Sendable` protocols.
public struct EnvironmentConfiguration: CustomReflectable, Sendable {
  /// Represents the available configuration keys.
  public enum Key: String {
    /// Disables assertion failures for errors.
    case disableAssertionFailureForError = "DISABLE_ASSERTION_FAILURE_FOR_ERROR"
    /// Disallows database rebuild.
    case disallowDatabaseRebuild = "DISALLOW_DATABASE_REBUILD"
    /// Overrides the onboarding process.
    case onboardingOveride = "ONBOARDING_OVERRIDE"
    /// Resets the application.
    case resetApplication = "RESET_APPLICATION"

    case releaseVersion = "RELEASE_VERSION"

    case reviewEngagementThreshold = "REVIEW_ENGAGEMENT_THRESHOLD"
  }

  /// The shared instance of `EnvironmentConfiguration`.
  public static let shared: EnvironmentConfiguration = .init()

  /// Indicates whether assertion failures for errors should be disabled.
  @EnvironmentProperty(Key.disableAssertionFailureForError)
  public var disableAssertionFailureForError: Bool

  /// Indicates whether database rebuild is disallowed.
  @EnvironmentProperty(Key.disallowDatabaseRebuild)
  public var disallowDatabaseRebuild: Bool

  /// Represents the onboarding override option.
  @EnvironmentProperty(Key.onboardingOveride)
  public var onboardingOveride: OnboardingOverrideOption

  /// Indicates whether the application should be reset.
  @EnvironmentProperty(Key.resetApplication)
  public var resetApplication: Bool

  /// Indicates whether the application should be reset.
  @EnvironmentProperty(Key.releaseVersion)
  public var releaseVersion: Bool

  /// The threshold of user engagement to trigger a review request.
  @EnvironmentProperty(Key.reviewEngagementThreshold)
  public var reviewEngagementThreshold: Int

  /// Provides a custom mirror for the `EnvironmentConfiguration` instance.
  public var customMirror: Mirror {
    Mirror(
      self,
      children: [
        "disableAssertionFailureForError": self.disableAssertionFailureForError,
        "disallowDatabaseRebuild": self.disallowDatabaseRebuild,
        "onboardingOveride": self.onboardingOveride,
        "resetApplication": self.resetApplication,
        "releaseVersion": self.releaseVersion,
        "reviewEngagementThreshold": self.reviewEngagementThreshold,
      ]
    )
  }

  /// Initializes a new instance of `EnvironmentConfiguration`.
  internal init() {}
}
