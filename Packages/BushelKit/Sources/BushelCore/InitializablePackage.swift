//
// InitializablePackage.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

public protocol InitializablePackage: CodablePackage {
  init()
}

public extension InitializablePackage {
  #warning("logging-note: let's log what is going on here")
  #warning("Might want to add parameters for creating data and creating directory.")
  @discardableResult
  static func createAt(_ fileURL: URL) throws -> Self {
    let library = self.init()
    try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: false)
    let metadataJSONPath = fileURL.appendingPathComponent(self.configurationFileWrapperKey)
    let data = try JSON.encoder.encode(library)
    try data.write(to: metadataJSONPath)
    return library
  }
}
