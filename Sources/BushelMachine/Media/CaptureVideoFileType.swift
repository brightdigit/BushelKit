//
//  CaptureVideoFileType.swift
//  BushelKit
//
//  Created by Leo Dion on 10/8/24.
//


public enum CaptureVideoFileType : String, Sendable, Codable {
  case quickTimeMovie
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
