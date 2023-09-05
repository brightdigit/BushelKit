//
// ObservableDownloader.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Combine) && canImport(Observation) && os(macOS)
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

    public private(set) var totalBytesWritten: Int64 = 0
    public private(set) var totalBytesExpectedToWrite: Int64?
    let resumeDataSubject = PassthroughSubject<Data, Never>()
    var task: URLSessionDownloadTask?
    // swiftlint:disable:next implicitly_unwrapped_optional
    var session: URLSession!
    var cancellables = [AnyCancellable]()
    let requestSubject = PassthroughSubject<DownloadRequest, Never>()
    let locationURLSubject = PassthroughSubject<URL, Never>()
    let downloadUpdate = PassthroughSubject<DownloadUpdate, Never>()
    var completion: ((Result<Void, Error>) -> Void)?

    let formatter = ByteCountFormatter()

    func onCompletion(_ result: Result<Void, Error>) {
      assert(completion != nil)
      completion?(result)
    }

    public var prettyBytesWritten: String {
      formatter.string(from: .init(value: .init(totalBytesWritten), unit: .bytes))
    }

    // swiftlint:disable:next function_body_length
    public init(
      configuration: URLSessionConfiguration? = nil,
      queue: OperationQueue? = nil,
      totalBytesExpectedToWrite: (some BinaryInteger)?
    ) {
      self.totalBytesExpectedToWrite = totalBytesExpectedToWrite.map(Int64.init(_:))
      super.init()
      let session = URLSession(
        configuration: configuration ?? .default,
        delegate: self,
        delegateQueue: queue
      )
      self.session = session

      let destinationFileURLPublisher = requestSubject.share().map(\.destinationFileURL)
      requestSubject.share()
        .map { downloadRequest -> URLSessionDownloadTask in
          let task = self.session.downloadTask(with: downloadRequest.downloadSourceURL)
          task.resume()
          return task
        }
        .assign(to: \.task, on: self)
        .store(in: &cancellables)

      resumeDataSubject.map { resumeData in
        let task = self.session.downloadTask(withResumeData: resumeData)
        task.resume()
        return task
      }
      .assign(to: \.task, on: self)
      .store(in: &cancellables)

      Publishers.CombineLatest(locationURLSubject, destinationFileURLPublisher)
        .map { sourceURL, destinationURL in
          Result {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
          }
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: self.onCompletion)
        .store(in: &cancellables)

      downloadUpdate.share().map(\.totalBytesWritten).assign(to: \.totalBytesWritten, on: self).store(in: &cancellables)
      downloadUpdate.share().map(\.totalBytesExpectedToWrite).assign(to: \.totalBytesExpectedToWrite, on: self).store(in: &cancellables)
    }

    public func cancel() {
      task?.cancel()
    }

    public func begin(from downloadSourceURL: URL, to destinationFileURL: URL, _ completion: @escaping (Result<Void, Error>) -> Void) {
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

    // periphery:ignore
    public func urlSession(
      _: URLSession,
      downloadTask _: URLSessionDownloadTask,
      didWriteData _: Int64,
      totalBytesWritten: Int64,
      totalBytesExpectedToWrite: Int64
    ) {
      self.downloadUpdate.send(.init(totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite))
    }

    public func urlSession(_: URLSession, task _: URLSessionTask, didCompleteWithError error: Error?) {
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
