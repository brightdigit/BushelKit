//
//  SPFontsDataType.swift
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

/// A data type representing font information.
public struct SPFontsDataType: Codable, Equatable, Sendable {
  /// The coding keys used for the Codable conformance.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case enabled
    case path
    case type
    case typefaces
    case valid
  }

  /// The name of the font.
  public let name: String
  /// A private framework representing the enabled state of the font.
  public let enabled: PrivateFramework
  /// The file path of the font.
  public let path: String
  /// The type of the font.
  public let type: TypeEnum
  /// The typefaces available for the font.
  public let typefaces: [Typeface]
  /// A private framework representing the valid state of the font.
  public let valid: PrivateFramework

  /// Initializes a new instance of `SPFontsDataType`.
  /// - Parameters:
  ///   - name: The name of the font.
  ///   - enabled: A private framework representing the enabled state of the font.
  ///   - path: The file path of the font.
  ///   - type: The type of the font.
  ///   - typefaces: The typefaces available for the font.
  ///   - valid: A private framework representing the valid state of the font.
  public init(
    name: String,
    enabled: PrivateFramework,
    path: String,
    type: TypeEnum,
    typefaces: [Typeface],
    valid: PrivateFramework
  ) {
    self.name = name
    self.enabled = enabled
    self.path = path
    self.type = type
    self.typefaces = typefaces
    self.valid = valid
  }
}
