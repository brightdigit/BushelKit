//
// ObservableDownloader.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Combine) && canImport(Observation) && (os(macOS) || os(iOS))
  import Combine
  import Foundation

  @Observable
  public class ObservableDownloader: NSObject, URLSessionDownloadDelegate {
    struct DownloadRequest {
      let downloadSourceURL: URL
      let destinationFileURL: URL
    }

    struct DownloadUpdate {
      let totalBytesWritten: Int64
      let totalBytesExpectedToWrite: Int64?
    }

    public internal(set) var totalBytesWritten: Int64 = 0
    public internal(set) var totalBytesExpectedToWrite: Int64?

    // swiftlint:disable:next implicitly_unwrapped_optional
    var session: URLSession!

    let resumeDataSubject = PassthroughSubject<Data, Never>()
    var task: URLSessionDownloadTask?

    var cancellables = [AnyCancellable]()
    let requestSubject = PassthroughSubject<DownloadRequest, Never>()
    let locationURLSubject = PassthroughSubject<URL, Never>()
    let downloadUpdate = PassthroughSubject<DownloadUpdate, Never>()
    var completion: ((Result<Void, any Error>) -> Void)?

    let formatter = ByteCountFormatter()

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
