//
//  InstallerImageMetadata.swift
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

public import BushelFoundation
internal import Foundation
public import OSVer

/// Represents metadata for an installer image.
public struct InstallerImageMetadata: Equatable, Sendable {
  /// The long name of the installer image.
  public let longName: String
  /// The default name of the installer image.
  public let defaultName: String
  /// The label name of the installer image.
  public let labelName: String
  /// The operating system version of the installer image.
  public let operatingSystem: OSVer
  /// The build version of the installer image, if available.
  public let buildVersion: String?
  /// The name of the image resource used for the installer image.
  public let imageResourceName: String
  /// The system name of the installer image.
  public let systemName: String
  /// The VM system ID of the installer image.
  public let vmSystemID: VMSystemID

  /// The short name of the installer image, which is a combination of the label name and default name.
  public var shortName: String {
    "\(self.labelName) (\(self.defaultName))"
  }

  /// Initializes a new instance of `InstallerImageMetadata`.
  /// - Parameters:
  ///   - longName: The long name of the installer image.
  ///   - defaultName: The default name of the installer image.
  ///   - labelName: The label name of the installer image.
  ///   - operatingSystem: The operating system version of the installer image.
  ///   - buildVersion: The build version of the installer image, if available.
  ///   - imageResourceName: The name of the image resource used for the installer image.
  ///   - systemName: The system name of the installer image.
  ///   - systemID: The VM system ID of the installer image.
  public init(
    longName: String,
    defaultName: String,
    labelName: String,
    operatingSystem: OSVer,
    buildVersion: String?,
    imageResourceName: String,
    systemName: String,
    systemID: VMSystemID
  ) {
    self.longName = longName
    self.defaultName = defaultName
    self.labelName = labelName
    self.operatingSystem = operatingSystem
    self.buildVersion = buildVersion
    self.imageResourceName = imageResourceName
    self.systemName = systemName
    self.vmSystemID = systemID
  }
}
