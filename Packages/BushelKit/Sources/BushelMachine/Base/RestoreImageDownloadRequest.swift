//
// RestoreImageDownloadRequest.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct RestoreImageDownloadRequest: Equatable {
  public init(sourceURL: URL, destination: RestoreImageDownloadDestination) {
    self.sourceURL = sourceURL
    self.destination = destination
  }

  public let sourceURL: URL
  public let destination: RestoreImageDownloadDestination
}
