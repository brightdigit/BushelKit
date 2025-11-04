//
//  InstallerImage.swift
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
public import BushelLogging
public import Foundation
public import OSVer

/// A protocol that represents an installer image for an operating system.
public protocol InstallerImage: OperatingSystemInstalled, Sendable {
  /// The type of metadata associated with the installer image.
  typealias Metadata = InstallerImageMetadata

  /// The library identifier associated with the installer image, if any.
  var libraryID: LibraryIdentifier? { get }

  /// The unique identifier of the installer image.
  var imageID: UUID { get }

  /// The metadata associated with the installer image.
  var metadata: Metadata { get }

  /// Retrieves the URL of the installer image.
  ///
  /// - Returns: The URL of the installer image.
  /// - Throws: An error if the URL cannot be retrieved.
  func getURL() async throws -> URL
}

extension InstallerImage {
  /// The operating system version associated with the installer image.
  public var operatingSystemVersion: OSVer {
    metadata.operatingSystem
  }

  /// The build version of the installer image, if available.
  public var buildVersion: String? {
    metadata.buildVersion
  }

  /// Retrieves the configuration range for the installer image using the provided machine system manager.
  ///
  /// - Parameter manager: The machine system manager to use for retrieving the configuration range.
  /// - Returns: The configuration range for the installer image.
  @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
  public func getConfigurationRange(from manager: any MachineSystemManaging) -> ConfigurationRange {
    let manager = manager.resolve(self.metadata.vmSystemID)
    return manager.configurationRange(for: self)
  }
}

extension InstallerImage where Self: Loggable {
  /// The logging category for the installer image.
  public static var loggingCategory: BushelLogging.Category {
    .library
  }
}

extension InstallerImage {
  /// The identifier for the installer image, which includes the image ID and library ID.
  public var identifier: InstallerImageIdentifier {
    InstallerImageIdentifier(imageID: imageID, libraryID: libraryID)
  }

  public var buildIdentifier: String {
    self.operatingSystemVersion.id(buildVersion: self.buildVersion)
  }
}
