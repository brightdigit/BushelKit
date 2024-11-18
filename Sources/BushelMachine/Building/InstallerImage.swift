//
//  InstallerImage.swift
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

public import BushelFoundation
public import BushelLogging
public import Foundation

public protocol InstallerImage: OperatingSystemInstalled, Sendable {
  typealias Metadata = InstallerImageMetadata
  var libraryID: LibraryIdentifier? { get }
  var imageID: UUID { get }
  var metadata: Metadata { get }
  func getURL() async throws -> URL
}

extension InstallerImage {
  public var operatingSystemVersion: OperatingSystemVersion {
    metadata.operatingSystem
  }

  public var buildVersion: String? {
    metadata.buildVersion
  }

  public func getConfigurationRange(from manager: any MachineSystemManaging) -> ConfigurationRange {
    let manager = manager.resolve(self.metadata.vmSystemID)
    return manager.configurationRange(for: self)
  }
}

extension InstallerImage where Self: Loggable {
  public static var loggingCategory: BushelLogging.Category {
    .library
  }
}

extension InstallerImage {
  public var identifier: InstallerImageIdentifier {
    InstallerImageIdentifier(imageID: imageID, libraryID: libraryID)
  }
}
