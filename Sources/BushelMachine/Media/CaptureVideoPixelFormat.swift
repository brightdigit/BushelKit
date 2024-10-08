//
//  CaptureVideoPixelFormat.swift
//  BushelKit
//
//  Created by Leo Dion on 10/8/24.
//




public enum CaptureVideoPixelFormat : String, Sendable, Codable {
  case BGRA32 = "32BGRA"
}
#if canImport(CoreVideo)
public import CoreVideo
extension CaptureVideoPixelFormat {
  public var osType: OSType {
    switch self {
    case .BGRA32:
      kCVPixelFormatType_32BGRA
    }
  }
}
#endif
