//
// FileManager.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  public import BushelCore

  public import RadiantProgress

  public import Foundation
  import Observation

  extension FileManager {
    @MainActor
    public static func fileOperationProgress(
      from sourceURL: URL,
      to destinationURL: URL,
      totalValue: Int?,
      timeInterval: TimeInterval,
      logger: Logger?
    ) throws -> any ProgressOperation<Int> {
      assert(logger != nil)
      if sourceURL.isFileURL {
        let fileHandler = FileManagerHandler(fileManager: {
          self.default
        })
        logger?.debug("Copying file \(sourceURL) to \(destinationURL)")
        return CopyOperation(
          sourceURL: sourceURL,
          destinationURL: destinationURL,
          totalValue: totalValue,
          timeInterval: timeInterval,
          logger: logger,
          getSize: { try fileHandler.sizeOf($0) },
          copyFile: { try await fileHandler.copyFile($0) }
        )
      } else {
        logger?.debug("Downloading file \(sourceURL) to \(destinationURL)")
        return DownloadOperation(
          sourceURL: sourceURL,
          destinationURL: destinationURL,
          totalBytesExpectedToWrite: totalValue
        )
      }
    }
  }

  extension FileHandler {
    func copyFile(_ paths: CopyPaths) async throws {
      try await self.copy(at: paths.fromURL, to: paths.toURL)
    }
  }

#endif
