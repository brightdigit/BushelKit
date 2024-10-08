//
//  CaptureVideoConfiguration.swift
//  BushelKit
//
//  Created by Leo Dion on 10/8/24.
//


public struct CaptureVideoConfiguration : Sendable, Codable {
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
  
  public static let `default` : CaptureVideoConfiguration = .init()
}
