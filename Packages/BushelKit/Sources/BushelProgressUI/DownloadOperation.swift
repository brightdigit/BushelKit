//
// DownloadOperation.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import Foundation
  import Observation

  @Observable
  public final class DownloadOperation<ValueType: BinaryInteger & Sendable>:

    Identifiable,
    ProgressOperation,
    Sendable {
    let download: ObservableDownloader
    let sourceURL: URL
    let destinationURL: URL

    public var id: URL {
      sourceURL
    }

    public var currentValue: ValueType {
      .init(download.totalBytesWritten)
    }

    public var totalValue: ValueType? {
      download.totalBytesExpectedToWrite.map(ValueType.init(_:))
    }

    public init(
      sourceURL: URL,
      destinationURL: URL,
      totalBytesExpectedToWrite: ValueType?,
      configuration: URLSessionConfiguration? = nil,
      queue: OperationQueue? = nil
    ) {
      assert(!sourceURL.isFileURL)
      assert(totalBytesExpectedToWrite != nil)
      self.sourceURL = sourceURL
      self.destinationURL = destinationURL
      self.download = .init(
        totalBytesExpectedToWrite: totalBytesExpectedToWrite,
        configuration: configuration,
        queue: queue
      )
    }

    public func execute() async throws {
      try await withCheckedThrowingContinuation {
        self.download.begin(from: self.sourceURL, to: self.destinationURL, $0.resume(with:))
      }
    }
  }

#endif
