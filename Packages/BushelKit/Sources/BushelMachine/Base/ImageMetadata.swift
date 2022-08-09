//
// ImageMetadata.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/9/22.
//

import Foundation
public struct ImageMetadata: Codable, CustomDebugStringConvertible, Hashable {
  public init(isImageSupported: Bool, buildVersion: String, operatingSystemVersion: OperatingSystemVersion, contentLength: Int, lastModified: Date, url: URL, vmSystem: VMSystemID) {
    self.isImageSupported = isImageSupported
    self.buildVersion = buildVersion
    self.operatingSystemVersion = operatingSystemVersion
    self.contentLength = contentLength
    self.lastModified = lastModified
    self.url = url
    self.vmSystem = vmSystem
  }

  public let isImageSupported: Bool
  public let buildVersion: String
  public let operatingSystemVersion: OperatingSystemVersion
  public let contentLength: Int
  public let lastModified: Date
  @available(*, deprecated)
  public let url: URL
  public let vmSystem: VMSystemID
  public var fileExtension: String {
    url.pathExtension
  }

  public var debugDescription: String {
    "\(Self.self)(isImageSupported: \(isImageSupported), buildVersion: \"\(buildVersion)\", operatingSystemVersion: \(operatingSystemVersion.debugDescription), contentLength: \(contentLength), lastModified: Date(timeIntervalSinceReferenceDate: \(lastModified.timeIntervalSinceReferenceDate)), url: \(url.debugDescription)"
  }
}

extension ImageMetadata {
  func withURL(_ url: URL) -> ImageMetadata {
    ImageMetadata(isImageSupported: isImageSupported, buildVersion: buildVersion, operatingSystemVersion: operatingSystemVersion, contentLength: contentLength, lastModified: lastModified, url: url, vmSystem: vmSystem)
  }
}
