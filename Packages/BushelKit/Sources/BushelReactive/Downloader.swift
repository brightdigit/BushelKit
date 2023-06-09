//
// Downloader.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Combine)
  import Combine
  import Foundation

  // periphery:ignore
  public class Downloader: NSObject, ObservableObject, URLSessionDownloadDelegate {
    struct DownloadRequest {
      let downloadSourceURL: URL
      let destinationFileURL: URL
    }

    @Published public private(set) var totalBytesWritten: Int64 = 0
    @Published public private(set) var totalBytesExpectedToWrite: Int64?
    @Published public private(set) var isCompleted: Result<Void, Error>?
    let resumeDataSubject = PassthroughSubject<Data, Never>()
    var task: URLSessionDownloadTask?
    // swiftlint:disable:next implicitly_unwrapped_optional
    var session: URLSession!
    var cancellables = [AnyCancellable]()
    let requestSubject = PassthroughSubject<DownloadRequest, Never>()
    let locationURLSubject = PassthroughSubject<URL, Never>()

    let formatter = ByteCountFormatter()

    public var prettyBytesWritten: String {
      formatter.string(from: .init(value: .init(totalBytesWritten), unit: .bytes))
    }

    public var prettyBytesTotal: String? {
      totalBytesExpectedToWrite.map {
        formatter.string(from: .init(value: .init($0), unit: .bytes))
      }
    }

    public var percentCompleted: Float? {
      totalBytesExpectedToWrite.map {
        Float((self.totalBytesWritten * 10000) / $0) / 10000
      }
    }

    public var localizedProgress: String? {
      guard let prettyBytesTotal = prettyBytesTotal else {
        return nil
      }
      return "\(prettyBytesWritten) / \(prettyBytesTotal)"
    }

    // swiftlint:disable:next function_body_length
    public init(
      configuration: URLSessionConfiguration? = nil,
      queue: OperationQueue? = nil
    ) {
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
        .assign(to: &$isCompleted)
    }

    public func cancel() {
      task?.cancel()
    }

    public func reset() {
      Task {
        await MainActor.run {
          self.totalBytesExpectedToWrite = nil
          self.isCompleted = nil
        }
      }
    }

    public func begin(from downloadSourceURL: URL, to destinationFileURL: URL) {
      requestSubject.send(
        .init(downloadSourceURL: downloadSourceURL, destinationFileURL: destinationFileURL)
      )
    }

    // periphery:ignore
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
      #warning("Swap for MainActor")
      DispatchQueue.main.async {
        self.totalBytesWritten = totalBytesWritten
        self.totalBytesExpectedToWrite = totalBytesExpectedToWrite
      }
    }

    public func urlSession(_: URLSession, task _: URLSessionTask, didCompleteWithError error: Error?) {
      guard let error = error else {
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
    }
  }
#endif
