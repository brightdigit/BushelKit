//
// CaptureVideo.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

public struct CaptureVideo: Sendable {
  public init(url: URL, configuration: CaptureVideoConfiguration) {
    self.url = url
    self.configuration = configuration
  }
  
  public let url: URL
  public let configuration : CaptureVideoConfiguration
}





