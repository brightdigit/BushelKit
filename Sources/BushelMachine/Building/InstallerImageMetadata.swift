//
//  InstallerImageMetadata.swift
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

public import BushelCore
public import Foundation

public struct InstallerImageMetadata: Equatable, Sendable {
  public let longName: String
  public let defaultName: String
  public let labelName: String
  public let operatingSystem: OperatingSystemVersion
  public let buildVersion: String?
  public let imageResourceName: String
  public let systemName: String
  public let vmSystemID: VMSystemID

  public var shortName: String {
    "\(labelName) (\(defaultName))"
  }

  public init(
    longName: String,
    defaultName: String,
    labelName: String,
    operatingSystem: OperatingSystemVersion,
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
