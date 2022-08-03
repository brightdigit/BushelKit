//
// Downloader.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

#if canImport(Combine)
  import Combine
  import Foundation

  public class Downloader: NSObject, ObservableObject, URLSessionDownloadDelegate {
    struct DownloadRequest {
      let downloadSourceURL: URL
      let destinationFileURL: URL
    }

    override public init() {
      super.init()
    }

    @Published var totalBytesWritten: Int64 = 0
    @Published var totalBytesExpectedToWrite: Int64?
    @Published var isCompleted: Result<Void, Error>?
    var task: URLSessionDownloadTask?
    var session: URLSession!
    var cancellable: AnyCancellable?
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

    var isActive: Bool {
      isCompleted == nil && task != nil
    }

    internal init(configuration: URLSessionConfiguration? = nil, queue: OperationQueue? = nil) {
      // self.downloadURL = downloadURL

      super.init()
      let session = URLSession(configuration: configuration ?? .default, delegate: self, delegateQueue: queue)

      self.session = session

      let destinationFileURLPublisher = requestSubject.share().map(\.destinationFileURL)
      cancellable = requestSubject.share().map { downloadRequest -> URLSessionDownloadTask in
        let task = self.session.downloadTask(with: downloadRequest.downloadSourceURL)
        task.resume()
        return task
      }.assign(to: \.task, on: self)
      Publishers.CombineLatest(locationURLSubject, destinationFileURLPublisher).map { sourceURL, destinationURL in
        Result {
          try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
        }
      }.receive(on: DispatchQueue.main).assign(to: &$isCompleted)

      // self.session = session
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
      requestSubject.send(.init(downloadSourceURL: downloadSourceURL, destinationFileURL: destinationFileURL))
      // task.resume()
    }

    public func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
      locationURLSubject.send(location)
    }

    public func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didWriteData _: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
      DispatchQueue.main.async {
        self.totalBytesWritten = totalBytesWritten
        self.totalBytesExpectedToWrite = totalBytesExpectedToWrite
      }
    }
  }
#endif
