//
// HubImage.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

#warning("Move to new module")
public struct HubImage: Identifiable, InstallImage {
  public init(title: String, metadata: ImageMetadata, url: URL) {
    self.title = title
    self.metadata = metadata
    self.url = url
  }

  public let title: String
  public let metadata: ImageMetadata
  public let url: URL
  public var id: URL {
    self.url
  }
}
