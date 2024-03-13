//
// FileManager.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import Foundation
  import Observation

  public extension FileManager {
    #warning("logging-note: let's log that a url is getting copied/downloaded")
    static func fileOperationProgress(
      from sourceURL: URL,
      to destinationURL: URL,
      totalValue: Int?
    ) throws -> any ProgressOperation<Int> {
      if sourceURL.isFileURL {
        try CopyOperation(
          fileManager: { .default },
          sourceURL: sourceURL,
          destinationURL: destinationURL
        )
      } else {
        DownloadOperation(
          sourceURL: sourceURL,
          destinationURL: destinationURL,
          totalBytesExpectedToWrite: totalValue
        )
      }
    }
  }

#endif
