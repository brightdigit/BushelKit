//
//  Typeface.swift
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

/// Represents a typeface in a font.
public struct Typeface: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case copyProtected = "copy_protected"
    case copyright
    case designer
    case duplicate
    case embeddable
    case enabled
    case family
    case fullname
    case outline
    case style
    case trademark
    case unique
    case valid
    case vendor
    case version
    case description
  }

  /// The name of the typeface.
  public let name: String
  /// Indicates whether the typeface is copy-protected.
  public let copyProtected: PrivateFramework
  /// The copyright information for the typeface.
  public let copyright: String
  /// The designer of the typeface.
  public let designer: String?
  /// Indicates whether the typeface is a duplicate.
  public let duplicate: PrivateFramework
  /// Indicates whether the typeface is embeddable.
  public let embeddable: PrivateFramework
  /// Indicates whether the typeface is enabled.
  public let enabled: PrivateFramework
  /// The font family of the typeface.
  public let family: String
  /// The full name of the typeface.
  public let fullname: String
  /// Indicates whether the typeface has an outline.
  public let outline: PrivateFramework
  /// The style of the typeface.
  public let style: String
  /// The trademark information for the typeface.
  public let trademark: String?
  /// A unique identifier for the typeface.
  public let unique: String
  /// Indicates whether the typeface is valid.
  public let valid: PrivateFramework
  /// The vendor of the typeface.
  public let vendor: String?
  /// The version of the typeface.
  public let version: String
  /// A description of the typeface.
  public let description: String?

  /// Initializes a new `Typeface` instance.
  /// - Parameters:
  ///   - name: The name of the typeface.
  ///   - copyProtected: Indicates whether the typeface is copy-protected.
  ///   - copyright: The copyright information for the typeface.
  ///   - designer: The designer of the typeface.
  ///   - duplicate: Indicates whether the typeface is a duplicate.
  ///   - embeddable: Indicates whether the typeface is embeddable.
  ///   - enabled: Indicates whether the typeface is enabled.
  ///   - family: The font family of the typeface.
  ///   - fullname: The full name of the typeface.
  ///   - outline: Indicates whether the typeface has an outline.
  ///   - style: The style of the typeface.
  ///   - trademark: The trademark information for the typeface.
  ///   - unique: A unique identifier for the typeface.
  ///   - valid: Indicates whether the typeface is valid.
  ///   - vendor: The vendor of the typeface.
  ///   - version: The version of the typeface.
  ///   - description: A description of the typeface.
  public init(
    name: String,
    copyProtected: PrivateFramework,
    copyright: String,
    designer: String?,
    duplicate: PrivateFramework,
    embeddable: PrivateFramework,
    enabled: PrivateFramework,
    family: String,
    fullname: String,
    outline: PrivateFramework,
    style: String,
    trademark: String?,
    unique: String,
    valid: PrivateFramework,
    vendor: String?,
    version: String,
    description: String?
  ) {
    self.name = name
    self.copyProtected = copyProtected
    self.copyright = copyright
    self.designer = designer
    self.duplicate = duplicate
    self.embeddable = embeddable
    self.enabled = enabled
    self.family = family
    self.fullname = fullname
    self.outline = outline
    self.style = style
    self.trademark = trademark
    self.unique = unique
    self.valid = valid
    self.vendor = vendor
    self.version = version
    self.description = description
  }
}
