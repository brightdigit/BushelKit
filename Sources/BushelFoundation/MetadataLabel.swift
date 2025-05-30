//
//  MetadataLabel.swift
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

public struct MetadataLabel: Equatable, Sendable {
  /// The long name of the operating system.
  public let operatingSystemLongName: String

  /// The default name of the metadata label.
  public let defaultName: String

  /// The name of the image associated with the metadata label.
  public let imageName: String

  /// The system name of the metadata label.
  public let systemName: String

  /// The version name of the metadata label.
  public let versionName: String

  /// The short version name of the metadata label.
  public let shortName: String

  /// Initializes a new instance of `MetadataLabel`.
  ///
  /// - Parameters:
  ///   - operatingSystemLongName: The long name of the operating system.
  ///   - defaultName: The default name of the metadata label.
  ///   - imageName: The name of the image associated with the metadata label.
  ///   - systemName: The system name of the metadata label.
  ///   - versionName: The version name of the metadata label.
  @Sendable
  public init(
    operatingSystemLongName: String,
    defaultName: String,
    imageName: String,
    systemName: String,
    versionName: String,
    shortName: String
  ) {
    self.operatingSystemLongName = operatingSystemLongName
    self.defaultName = defaultName
    self.imageName = imageName
    self.systemName = systemName
    self.versionName = versionName
    self.shortName = shortName
  }
}
