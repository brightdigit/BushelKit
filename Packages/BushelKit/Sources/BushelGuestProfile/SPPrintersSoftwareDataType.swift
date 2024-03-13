//
// SPPrintersSoftwareDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPPrintersSoftwareDataType

public struct SPPrintersSoftwareDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
    case name = "_name"
    case imageCaptureSupport = "image capture support"
    case extensions
  }

  public let name: String
  public let imageCaptureSupport: [Extension]?
  public let extensions: [Extension]?

  public init(name: String, imageCaptureSupport: [Extension]?, extensions: [Extension]?) {
    self.name = name
    self.imageCaptureSupport = imageCaptureSupport
    self.extensions = extensions
  }
}
