//
//  Typeface.swift
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

// MARK: - Typeface

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

  public let name: String
  public let copyProtected: PrivateFramework
  public let copyright: String
  public let designer: String?
  public let duplicate: PrivateFramework
  public let embeddable: PrivateFramework
  public let enabled: PrivateFramework
  public let family: String
  public let fullname: String
  public let outline: PrivateFramework
  public let style: String
  public let trademark: String?
  public let unique: String
  public let valid: PrivateFramework
  public let vendor: String?
  public let version: String
  public let description: String?

  // swiftlint:disable:next line_length
  public init(name: String, copyProtected: PrivateFramework, copyright: String, designer: String?, duplicate: PrivateFramework, embeddable: PrivateFramework, enabled: PrivateFramework, family: String, fullname: String, outline: PrivateFramework, style: String, trademark: String?, unique: String, valid: PrivateFramework, vendor: String?, version: String, description: String?) {
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
