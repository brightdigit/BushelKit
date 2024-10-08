//
//  ImageFileType.swift
//  BushelKit
//
//  Created by Leo Dion on 10/8/24.
//


public enum ImageFileType: Sendable, Codable {
  case jpeg
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