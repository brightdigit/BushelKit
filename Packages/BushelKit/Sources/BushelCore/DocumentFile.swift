//
// DocumentFile.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct DocumentFile<FileType: FileTypeSpecification>: Codable, Hashable {
  public let url: URL

  public init(url: URL) {
    self.url = url
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(url)
  }
}

public extension DocumentFile {
  static func documentFile(from url: URL) -> Self? {
    guard url.pathExtension == FileType.fileType.fileExtension else {
      return nil
    }
    return Self(url: url)
  }
}
