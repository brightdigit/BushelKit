//
// ImageMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation
import OperatingSystemVersion

/// Represents metadata associated with an image file.
public struct ImageMetadata: Codable,
  CustomDebugStringConvertible,
  Hashable,
  OperatingSystemInstalled,
  Sendable {
  /// Indicates whether the image format is supported by the system.
  public let isImageSupported: Bool
  /// The build version associated with the image, if available.
  public let buildVersion: String?
  /// The operating system version the image is intended for.
  public let operatingSystemVersion: OperatingSystemVersion
  /// The size of the image file in bytes.
  public let contentLength: Int
  /// The last modification date of the image file.
  public let lastModified: Date
  /// The virtual machine system identifier associated with the image.
  public let vmSystemID: VMSystemID
  /// The file extension of the image.
  public let fileExtension: String

  /// A custom debug description string providing details about the image metadata.
  public var debugDescription: String {
    // swiftlint:disable:next line_length
    "\(Self.self)(isImageSupported: \(isImageSupported), buildVersion: \"\(buildVersion ?? "")\", operatingSystemVersion: \(operatingSystemVersion.debugDescription), contentLength: \(contentLength), lastModified: Date(timeIntervalSinceReferenceDate: \(lastModified.timeIntervalSinceReferenceDate))"
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
  ///   - vmSystemID: The virtual machine system identifier associated with the image.
  public init(
    isImageSupported: Bool,
    buildVersion: String?,
    operatingSystemVersion: OperatingSystemVersion,
    contentLength: Int,
    lastModified: Date,
    fileExtension: String,
    vmSystemID: VMSystemID
  ) {
    self.isImageSupported = isImageSupported
    self.buildVersion = buildVersion
    self.operatingSystemVersion = operatingSystemVersion
    self.contentLength = contentLength
    self.lastModified = lastModified
    self.fileExtension = fileExtension
    self.vmSystemID = vmSystemID
  }
}
