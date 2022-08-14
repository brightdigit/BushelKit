//
// RestoreImageDownloadRequest.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
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
