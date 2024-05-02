//
// FileManager.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelProgressUI
  import Foundation
  import Observation

  public extension FileManager {
    #warning("logging-note: let's log that a url is getting copied/downloaded")
    static func fileOperationProgress(
      from sourceURL: URL,
      to destinationURL: URL,
      totalValue: Int?,
      timeInterval: TimeInterval,
      logger: Logger?
    ) throws -> any ProgressOperation<Int> {
      if sourceURL.isFileURL {
        let fileHandler = FileManagerHandler(fileManager: {
          self.default
        })
        return CopyOperation(
          sourceURL: sourceURL,
          destinationURL: destinationURL,
          totalValue: totalValue,
          timeInterval: timeInterval,
          logger: logger,
          getSize: { try await fileHandler.getSize($0) },
          copyFile: { try await fileHandler.copyFile($0) }
        )
      } else {
        return DownloadOperation(
          sourceURL: sourceURL,
          destinationURL: destinationURL,
          totalBytesExpectedToWrite: totalValue
        )
      }
    }
  }

  extension FileHandler {
    func getSize(_ url: URL) async throws -> Int? {
      try await self.attributesAt(url).get(.size)
    }

    func copyFile(_ paths: CopyPaths) async throws {
      try await self.copy(at: paths.fromURL, to: paths.toURL)
    }
  }

#endif
