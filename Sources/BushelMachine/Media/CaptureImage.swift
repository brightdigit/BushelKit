//
// CaptureImage.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

public struct CaptureImage: Sendable {
  public init(url: URL, configuration: CaptureImage.Configuration) {
    self.url = url
    self.configuration = configuration
  }
  
  public enum FileType: Sendable {
    case jpeg
  }

  public struct Configuration: Sendable {
    public static let `default` = Configuration(compression: 0.8, fileType: .jpeg)

    public let compression: Double
    public let fileType: FileType
  }

  public let url: URL
  public let configuration: Configuration
}

#if canImport(UniformTypeIdentifiers)
  public import UniformTypeIdentifiers

  extension UTType {
    public init(fileType: CaptureImage.FileType) {
      switch fileType {
      case .jpeg:
        self = UTType.jpeg
      }
    }
  }

#endif
