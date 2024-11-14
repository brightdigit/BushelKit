//
//  OnboardingOverrideOption.swift
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

public import Foundation
public import BushelUtilities

/// Represents an option for overriding the onboarding flow.
public enum OnboardingOverrideOption: String, EnvironmentValue {
  case skip
  case force
  case none

  /// The default `OnboardingOverrideOption` value.
  public static let `default`: OnboardingOverrideOption = .none
}

extension OnboardingOverrideOption {
  /// Determines whether the onboarding flow should be displayed
  /// based on the current `OnboardingOverrideOption` and an optional `Date`.
  ///
  /// - Parameter date: An optional `Date` value.
  /// - Returns: A `Bool` indicating whether the onboarding flow should be displayed.
  public func shouldBasedOn(date: Date?) -> Bool {
    switch (self, date) {
    case (.skip, _):
      false
    case (.force, _):
      true
    case (.none, .some):
      false
    case (.none, .none):
      true
    }
  }
}