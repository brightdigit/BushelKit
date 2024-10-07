//
// CaptureImage.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

public enum ImageFileType: Sendable {
  case jpeg
}

public struct CaptureImage: Sendable {
  public init(url: URL, configuration: CaptureImage.Configuration) {
    self.url = url
    self.configuration = configuration
  }
  


  public struct Configuration: Sendable {
    public static let `default` = Configuration(compression: 0.8, fileType: .jpeg)

    public let compression: Double
    public let fileType: ImageFileType
  }

  public let url: URL
  public let configuration: Configuration
}

#if canImport(UniformTypeIdentifiers)
  public import UniformTypeIdentifiers

  extension UTType {
    public init(imageType: ImageFileType) {
      switch imageType {
      case .jpeg:
        self = UTType.jpeg
      }
    }
  }

#endif
