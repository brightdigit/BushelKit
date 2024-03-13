//
// ImageMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation
import OperatingSystemVersion

public struct ImageMetadata: Codable,
  CustomDebugStringConvertible,
  Hashable,
  OperatingSystemInstalled,
  Sendable {
  public let isImageSupported: Bool
  public let buildVersion: String?
  public let operatingSystemVersion: OperatingSystemVersion
  public let contentLength: Int
  public let lastModified: Date
  public let vmSystemID: VMSystemID
  public let fileExtension: String

  public var debugDescription: String {
    // swiftlint:disable:next line_length
    "\(Self.self)(isImageSupported: \(isImageSupported), buildVersion: \"\(buildVersion ?? "")\", operatingSystemVersion: \(operatingSystemVersion.debugDescription), contentLength: \(contentLength), lastModified: Date(timeIntervalSinceReferenceDate: \(lastModified.timeIntervalSinceReferenceDate))"
  }

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
