//
// CaptureImage.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation


public struct CaptureImage: Sendable {
  public init(url: URL, configuration: CaptureImageConfiguration) {
    self.url = url
    self.configuration = configuration
  }
  




  public let url: URL
  public let configuration: CaptureImageConfiguration
}


