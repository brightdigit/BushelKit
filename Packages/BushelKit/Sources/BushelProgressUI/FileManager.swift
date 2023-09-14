//
// FileManager.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import Foundation
  import Observation

  public extension FileManager {
    func fileOperationProgress(
      from sourceURL: URL,
      to destinationURL: URL,
      totalValue: Int?
    ) throws -> any ProgressOperation<Int> {
      if sourceURL.isFileURL {
        try CopyOperation(
          fileManager: self,
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
