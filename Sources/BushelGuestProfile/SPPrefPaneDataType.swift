//
//  SPPrefPaneDataType.swift
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

// MARK: - SPPrefPaneDataType

public struct SPPrefPaneDataType: Codable, Equatable, Sendable {
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spprefpaneBundlePath = "spprefpane_bundlePath"
    case spprefpaneIdentifier = "spprefpane_identifier"
    case spprefpaneIsVisible = "spprefpane_isVisible"
    case spprefpaneKind = "spprefpane_kind"
    case spprefpaneSupport = "spprefpane_support"
    case spprefpaneVersion = "spprefpane_version"
  }

  public let name: String
  public let spprefpaneBundlePath: String
  public let spprefpaneIdentifier: String
  public let spprefpaneIsVisible: PrivateFramework
  public let spprefpaneKind: SpprefpaneKind
  public let spprefpaneSupport: SpprefpaneSupport
  public let spprefpaneVersion: String

  // swiftlint:disable:next line_length
  public init(name: String, spprefpaneBundlePath: String, spprefpaneIdentifier: String, spprefpaneIsVisible: PrivateFramework, spprefpaneKind: SpprefpaneKind, spprefpaneSupport: SpprefpaneSupport, spprefpaneVersion: String) {
    self.name = name
    self.spprefpaneBundlePath = spprefpaneBundlePath
    self.spprefpaneIdentifier = spprefpaneIdentifier
    self.spprefpaneIsVisible = spprefpaneIsVisible
    self.spprefpaneKind = spprefpaneKind
    self.spprefpaneSupport = spprefpaneSupport
    self.spprefpaneVersion = spprefpaneVersion
  }
}
