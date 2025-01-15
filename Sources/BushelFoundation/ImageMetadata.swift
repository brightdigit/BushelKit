//
//  ImageMetadata.swift
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

public import Foundation
public import OSVer

/// Represents metadata associated with an image file.
public struct ImageMetadata: Codable,
  CustomDebugStringConvertible,
  Hashable,
  OperatingSystemInstalled,
  Sendable
{
  /// Indicates whether the image format is supported by the system.
  public let isImageSupported: Bool
  /// The build version associated with the image, if available.
  public let buildVersion: String?
  /// The operating system version the image is intended for.
  public let operatingSystemVersion: OSVer
  /// The size of the image file in bytes.
  public let contentLength: Int
  /// The last modification date of the image file.
  public let lastModified: Date
  /// The virtual machine system identifier associated with the image.
  public let vmSystemID: VMSystemID
  /// The file extension of the image.
  public let fileExtension: String

  public let sigVerification: SigVerification?

  /// A custom debug description string providing details about the image metadata.
  public var debugDescription: String {
    // swiftlint:disable:next line_length
    "\(Self.self)(isImageSupported: \(self.isImageSupported), buildVersion: \"\(self.buildVersion ?? "")\", operatingSystemVersion: \(self.operatingSystemVersion.description), contentLength: \(self.contentLength), lastModified: Date(timeIntervalSinceReferenceDate: \(self.lastModified.timeIntervalSinceReferenceDate))"
  }

  /// Creates a new `ImageMetadata` instance.
  ///
  /// - Parameters:
  ///   - isImageSupported: Indicates whether the image format is supported.
  ///   - buildVersion: The build version associated with the image (optional).
  ///   - operatingSystemVersion: The operating system version the image is intended for.
  ///   - contentLength: The size of the image file in bytes.
  ///   - lastModified: The last modification date of the image file.
  ///   - fileExtension: The file extension of the image (e.g., ".dmg", ".iso").
  ///   - sigVerification: The signature verification information for the image (optional).
  ///   - vmSystemID: The virtual machine system identifier associated with the image.
  public init(
    isImageSupported: Bool,
    buildVersion: String?,
    operatingSystemVersion: OSVer,
    contentLength: Int,
    lastModified: Date,
    fileExtension: String,
    sigVerification: SigVerification?,
    vmSystemID: VMSystemID
  ) {
    self.isImageSupported = isImageSupported
    self.buildVersion = buildVersion
    self.operatingSystemVersion = operatingSystemVersion
    self.contentLength = contentLength
    self.lastModified = lastModified
    self.fileExtension = fileExtension
    self.sigVerification = sigVerification
    self.vmSystemID = vmSystemID
  }
}
