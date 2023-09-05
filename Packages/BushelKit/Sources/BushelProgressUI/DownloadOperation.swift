//
// DownloadOperation.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && os(macOS)
  import Foundation
  import Observation

  extension DownloadOperation: ProgressOperation {}

  @Observable
  public class DownloadOperation<ValueType: BinaryInteger>: NSObject, Identifiable {
    internal init(
      configuration: URLSessionConfiguration? = nil,
      queue: OperationQueue? = nil,
      sourceURL: URL,
      destinationURL: URL,
      totalBytesExpectedToWrite: ValueType?
    ) {
      assert(!sourceURL.isFileURL)
      assert(totalBytesExpectedToWrite != nil)
      self.sourceURL = sourceURL
      self.destinationURL = destinationURL
      self.download = .init(configuration: configuration, queue: queue, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }

    let download: ObservableDownloader
    let sourceURL: URL
    let destinationURL: URL

    public var id: URL {
      sourceURL
    }

    public func execute() async throws {
      try await withCheckedThrowingContinuation {
        self.download.begin(from: self.sourceURL, to: self.destinationURL, $0.resume(with:))
      }
    }

    public var currentValue: ValueType {
      .init(download.totalBytesWritten)
    }

    public var totalValue: ValueType? {
      download.totalBytesExpectedToWrite.map(ValueType.init(_:))
    }
  }

#endif
