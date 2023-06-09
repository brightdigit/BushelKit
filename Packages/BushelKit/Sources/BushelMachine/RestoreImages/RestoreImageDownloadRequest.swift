//
// RestoreImageDownloadRequest.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct RestoreImageDownloadRequest: Equatable {
  public let sourceURL: URL
  public let destination: RestoreImageDownloadDestination
  public init(sourceURL: URL, destination: RestoreImageDownloadDestination) {
    self.sourceURL = sourceURL
    self.destination = destination
  }
}
