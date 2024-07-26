//
//  DownloadOperation.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  public import Foundation
  import Observation

  @MainActor
  @Observable
  public final class DownloadOperation<ValueType: BinaryInteger & Sendable>:

    Identifiable,
    ProgressOperation,
    Sendable {
    private let download: ObservableDownloader
    private let sourceURL: URL
    private let destinationURL: URL

    public nonisolated var id: URL {
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
      try await withCheckedThrowingContinuation { continuation in
        self.download.begin(from: self.sourceURL, to: self.destinationURL) { result in
          continuation.resume(with: result)
        }
      }
    }
  }

#endif
