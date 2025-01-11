//
//  SPPrefPaneDataType.swift
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

/// A struct representing the data type for a System Preferences pane.
public struct SPPrefPaneDataType: Codable, Equatable, Sendable {
  /// The coding keys used for encoding and decoding the struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spprefpaneBundlePath = "spprefpane_bundlePath"
    case spprefpaneIdentifier = "spprefpane_identifier"
    case spprefpaneIsVisible = "spprefpane_isVisible"
    case spprefpaneKind = "spprefpane_kind"
    case spprefpaneSupport = "spprefpane_support"
    case spprefpaneVersion = "spprefpane_version"
  }

  /// The name of the System Preferences pane.
  public let name: String
  /// The bundle path of the System Preferences pane.
  public let spprefpaneBundlePath: String
  /// The identifier of the System Preferences pane.
  public let spprefpaneIdentifier: String
  /// The visibility status of the System Preferences pane.
  public let spprefpaneIsVisible: PrivateFramework
  /// The kind of the System Preferences pane.
  public let spprefpaneKind: SpprefpaneKind
  /// The support information of the System Preferences pane.
  public let spprefpaneSupport: SpprefpaneSupport
  /// The version of the System Preferences pane.
  public let spprefpaneVersion: String

  /// Initializes a new instance of `SPPrefPaneDataType` with the given parameters.
  /// - Parameters:
  ///   - name: The name of the System Preferences pane.
  ///   - spprefpaneBundlePath: The bundle path of the System Preferences pane.
  ///   - spprefpaneIdentifier: The identifier of the System Preferences pane.
  ///   - spprefpaneIsVisible: The visibility status of the System Preferences pane.
  ///   - spprefpaneKind: The kind of the System Preferences pane.
  ///   - spprefpaneSupport: The support information of the System Preferences pane.
  ///   - spprefpaneVersion: The version of the System Preferences pane.
  public init(
    name: String,
    spprefpaneBundlePath: String,
    spprefpaneIdentifier: String,
    spprefpaneIsVisible: PrivateFramework,
    spprefpaneKind: SpprefpaneKind,
    spprefpaneSupport: SpprefpaneSupport,
    spprefpaneVersion: String
  ) {
    self.name = name
    self.spprefpaneBundlePath = spprefpaneBundlePath
    self.spprefpaneIdentifier = spprefpaneIdentifier
    self.spprefpaneIsVisible = spprefpaneIsVisible
    self.spprefpaneKind = spprefpaneKind
    self.spprefpaneSupport = spprefpaneSupport
    self.spprefpaneVersion = spprefpaneVersion
  }
}
