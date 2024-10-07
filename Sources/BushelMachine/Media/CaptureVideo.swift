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

public enum CaptureVideoFileType : Sendable {
  case quickTimeMovie
}

public enum CaptureVideoPixelFormat : Sendable {
  case BGRA32
}
public enum CaptureVideoCodec : Sendable {
  case h264
}

public struct CaptureVideoConfiguration : Sendable {
  private init(
    format: CaptureVideoPixelFormat = .BGRA32,
    fileType: CaptureVideoFileType = .quickTimeMovie,
    codec: CaptureVideoCodec = .h264,
    height: Int = defaultHeight
  ) {
    self.format = format
    self.fileType = fileType
    self.codec = codec
    self.height = height
  }
  
 public let format : CaptureVideoPixelFormat
 public let fileType : CaptureVideoFileType
  public let codec : CaptureVideoCodec
 public let height: Int
  
  static let defaultHeight = 1_080
  
  static let `default` : CaptureVideoConfiguration = .init()
}

#if canImport(UniformTypeIdentifiers)
public import UniformTypeIdentifiers

extension UTType {
  public init (videoType: CaptureVideoFileType) {
    switch videoType {
    case .quickTimeMovie:
      self = .quickTimeMovie
    }
  }
}
#endif
