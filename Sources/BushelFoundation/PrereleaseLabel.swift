//
//  PrereleaseLabel.swift
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

internal import Foundation

/// Represents a prerelease label with a base number.
public struct PrereleaseLabel: Sendable {
  /// The prerelease label.
  public let label: String
  private let baseNumber: Int
  private let factor: Int

  /// Initializes a new instance of `PrereleaseLabel`.
  ///
  /// - Parameters:
  ///   - label: The prerelease label.
  ///   - baseNumber: The base number for the prerelease label.
  public init(label: String, baseNumber: Int, factor: Int) {
    self.label = label
    self.baseNumber = baseNumber
    self.factor = factor
  }
}

extension PrereleaseLabel {
  /// Represents the keys used in the prerelease label dictionary.
  public enum Keys: String {
    /// The key for the prerelease label.
    case label = "Label"
    /// The key for the base number.
    case base = "Base"
    /// The key for the factor of the offset
    case factor = "Factor"
  }

  /// Initializes a new instance of `PrereleaseLabel` from a dictionary.
  ///
  /// - Parameter dictionary: The dictionary containing the prerelease label information.
  /// - Returns: An instance of `PrereleaseLabel`, or `nil`
  /// if the dictionary is missing the required information.
  public init?(dictionary: [String: Any]) {
    guard
      let label = dictionary[Keys.label.rawValue] as? String,
      let base = dictionary[Keys.base.rawValue] as? Int
    else {
      assertionFailure("Bundle InfoDictionary Missing Label and Base for Prerelease Info")
      return nil
    }
    #if DEBUG
      if EnvironmentConfiguration.shared.releaseVersion {
        return nil
      }
    #endif
    let factor = dictionary[Keys.factor.rawValue] as? Int ?? 1
    self.init(label: label, baseNumber: base, factor: factor)
  }

  /// Calculates the offset from the build number based on the prerelease label.
  ///
  /// - Parameters:
  ///   - buildNumber: The current build number.
  ///   - additionalOffset: An additional offset to apply.
  ///   - factor: The factor to divide the result by.
  /// - Returns: The calculated offset.
  public func offset(
    fromBuildNumber buildNumber: Int,
    additionalOffset: Int
  ) -> Int {
    (buildNumber - self.baseNumber + additionalOffset) / self.factor
  }
}
