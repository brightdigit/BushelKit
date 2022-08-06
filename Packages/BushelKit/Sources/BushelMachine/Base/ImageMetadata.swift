//
// ImageMetadata.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import Foundation
public struct ImageMetadata: Codable, CustomDebugStringConvertible, Hashable {
  public init(isImageSupported: Bool, buildVersion: String, operatingSystemVersion: OperatingSystemVersion, sha256: SHA256, contentLength: Int, lastModified: Date, url: URL, vmSystem: VMSystemID) {
    self.isImageSupported = isImageSupported
    self.buildVersion = buildVersion
    self.operatingSystemVersion = operatingSystemVersion
    self.sha256 = sha256
    self.contentLength = contentLength
    self.lastModified = lastModified
    self.url = url
    self.vmSystem = vmSystem
  }

  public let isImageSupported: Bool
  public let buildVersion: String
  public let operatingSystemVersion: OperatingSystemVersion
  public let sha256: SHA256
  public let contentLength: Int
  public let lastModified: Date
  @available(*, deprecated)
  public let url: URL
  public let vmSystem: VMSystemID

  public var debugDescription: String {
    "\(Self.self)(isImageSupported: \(isImageSupported), buildVersion: \"\(buildVersion)\", operatingSystemVersion: \(operatingSystemVersion.debugDescription), sha256: \(sha256.debugDescription), contentLength: \(contentLength), lastModified: Date(timeIntervalSinceReferenceDate: \(lastModified.timeIntervalSinceReferenceDate)), url: \(url.debugDescription)"
  }
}

extension ImageMetadata {
  func withURL(_ url: URL) -> ImageMetadata {
    ImageMetadata(isImageSupported: isImageSupported, buildVersion: buildVersion, operatingSystemVersion: operatingSystemVersion, sha256: sha256, contentLength: contentLength, lastModified: lastModified, url: url, vmSystem: vmSystem)
  }
}
