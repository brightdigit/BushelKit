//
// HubImage.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public struct HubImage: Identifiable, InstallImage {
  public let title: String
  public let metadata: ImageMetadata
  public let url: URL
  public var id: URL { self.url }

  public init(title: String, metadata: ImageMetadata, url: URL) {
    self.title = title
    self.metadata = metadata
    self.url = url
  }
}
