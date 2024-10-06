//
// CaptureVideo.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

public struct CaptureVideo: Sendable {
  public init(url: URL) {
    self.url = url
  }
  
  public let url: URL
}
