//
// ImageMetadata.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
public struct ImageMetadata: Codable, CustomDebugStringConvertible, Hashable {
  public let isImageSupported: Bool
  public let buildVersion: String
  public let operatingSystemVersion: OperatingSystemVersion
  public let contentLength: Int
  public let lastModified: Date
  public let vmSystem: VMSystemID
  public let fileExtension: String

  public var debugDescription: String {
    // swiftlint:disable:next line_length
    "\(Self.self)(isImageSupported: \(isImageSupported), buildVersion: \"\(buildVersion)\", operatingSystemVersion: \(operatingSystemVersion.debugDescription), contentLength: \(contentLength), lastModified: Date(timeIntervalSinceReferenceDate: \(lastModified.timeIntervalSinceReferenceDate))"
  }

  public init(
    isImageSupported: Bool,
    buildVersion: String,
    operatingSystemVersion: OperatingSystemVersion,
    contentLength: Int,
    lastModified: Date,
    fileExtension: String,
    vmSystem: VMSystemID
  ) {
    self.isImageSupported = isImageSupported
    self.buildVersion = buildVersion
    self.operatingSystemVersion = operatingSystemVersion
    self.contentLength = contentLength
    self.lastModified = lastModified
    self.fileExtension = fileExtension
    self.vmSystem = vmSystem
  }
}

public extension ImageMetadata {
  var defaultName: String {
    AnyImageManagers.imageManager(forSystem: vmSystem)?.defaultName(for: self) ?? ""
  }
}
