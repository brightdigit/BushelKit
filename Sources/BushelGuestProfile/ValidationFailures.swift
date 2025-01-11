//
//  ValidationFailures.swift
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

public import Foundation

/// Represents validation failures that can occur during the validation of an info dictionary.
public struct ValidationFailures: Codable, Equatable, Sendable {
  /// The coding keys used to encode and decode the `ValidationFailures` struct.
  public enum CodingKeys: String, CodingKey {
    /// Represents the case where the info dictionary is missing a required property or value.
    case missingRequiredPropertyValues =
      "Info dictionary missing required property/value"
    /// Represents the case where the info dictionary property value is illegal.
    case illegalPropertyValues = "Info dictionary property value is illegal"
  }

  /// An array of strings representing the properties or values that are missing from the info dictionary.
  public let missingRequiredPropertyValues: [String]
  /// An array of strings representing the illegal property values in the info dictionary.
  public let illegalPropertyValues: [String]

  /// Initializes a `ValidationFailures` instance with the specified
  /// missing required properties/values and illegal property values.
  /// - Parameters:
  ///   - missingRequiredPropertyValue: An array of strings
  ///   representing the missing required properties or values.
  ///   - infoDictionaryPropertyValueIsIllegal: An array of strings
  ///   representing the illegal property values.
  public init(
    missingRequiredPropertyValues: [String],
    illegalPropertyValues: [String]
  ) {
    self.missingRequiredPropertyValues = missingRequiredPropertyValues
    self.illegalPropertyValues = illegalPropertyValues
  }
}
