//
//  ObservableDownloader.swift
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

#if canImport(Combine) && canImport(Observation) && (os(macOS) || os(iOS))
  import Combine
  import Foundation

  @Observable
  public final class ObservableDownloader: NSObject, URLSessionDownloadDelegate, Sendable {
    internal struct DownloadRequest {
      internal let downloadSourceURL: URL
      internal let destinationFileURL: URL
    }

    internal struct DownloadUpdate: Sendable {
      internal let totalBytesWritten: Int64
      internal let totalBytesExpectedToWrite: Int64?
    }

    public internal(set) var totalBytesWritten: Int64 = 0
    public internal(set) var totalBytesExpectedToWrite: Int64?

    // swiftlint:disable:next implicitly_unwrapped_optional
    internal private(set) var session: URLSession!

    internal let resumeDataSubject = PassthroughSubject<Data, Never>()
    internal var task: URLSessionDownloadTask?

    private var cancellables = [AnyCancellable]()
    internal let requestSubject = PassthroughSubject<DownloadRequest, Never>()
    internal let locationURLSubject = PassthroughSubject<URL, Never>()
    internal let downloadUpdate = PassthroughSubject<DownloadUpdate, Never>()
    private var completion: ((Result<Void, any Error>) -> Void)?

    private let formatter = ByteCountFormatter()

    public var prettyBytesWritten: String {
      formatter.string(from: .init(value: .init(totalBytesWritten), unit: .bytes))
    }

    public convenience init(
      totalBytesExpectedToWrite: (some BinaryInteger)?,
      setupPublishers: SetupPublishers = .init(),
      configuration: URLSessionConfiguration? = nil,
      queue: OperationQueue? = nil
    ) {
      self.init(
        totalBytesExpectedToWrite: totalBytesExpectedToWrite,
        setupPublishers: setupPublishers.callAsFunction(downloader:),
        configuration: configuration,
        queue: queue
      )
    }

    public init(
      totalBytesExpectedToWrite: (some BinaryInteger)?,
      setupPublishers: @escaping (ObservableDownloader) -> [AnyCancellable],
      configuration: URLSessionConfiguration? = nil,
      queue: OperationQueue? = nil
    ) {
      self.totalBytesExpectedToWrite = totalBytesExpectedToWrite.map(Int64.init(_:))
      super.init()
      self.session = URLSession(
        configuration: configuration ?? .default,
        delegate: self,
        delegateQueue: queue
      )

      self.cancellables = setupPublishers(self)
    }

    func onCompletion(_ result: Result<Void, any Error>) {
      assert(completion != nil)
      completion?(result)
    }

    public func cancel() {
      task?.cancel()
    }

    public func begin(
      from downloadSourceURL: URL,
      to destinationFileURL: URL,
      _ completion: @escaping (Result<Void, any Error>
      ) -> Void
    ) {
      assert(self.completion == nil)
      self.completion = completion
      requestSubject.send(
        .init(downloadSourceURL: downloadSourceURL, destinationFileURL: destinationFileURL)
      )
    }

    public func urlSession(
      _: URLSession,
      downloadTask _: URLSessionDownloadTask,
      didFinishDownloadingTo location: URL
    ) {
      locationURLSubject.send(location)
    }

    public func urlSession(
      _: URLSession,
      downloadTask _: URLSessionDownloadTask,
      didWriteData _: Int64,
      totalBytesWritten: Int64,
      totalBytesExpectedToWrite: Int64
    ) {
      self.downloadUpdate.send(
        .init(totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
      )
    }

    public func urlSession(
      _: URLSession,
      task _: URLSessionTask,
      didCompleteWithError error: (any Error)?
    ) {
      guard let error else {
        // Handle success case.
        return
      }
      let userInfo = (error as NSError).userInfo
      if let resumeData = userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
        resumeDataSubject.send(resumeData)
      }
    }

    deinit {
      self.cancellables.forEach { $0.cancel() }
      self.cancellables.removeAll()
      self.session = nil
      self.task = nil
    }
  }
#endif
