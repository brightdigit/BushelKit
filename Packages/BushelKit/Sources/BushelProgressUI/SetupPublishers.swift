//
// SetupPublishers.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Combine)
  import Combine
  import Foundation

  #warning("logging-note: can we have some operators for logging the recieved stuff in these subscriptions")
  public struct SetupPublishers {
    public init() {}

    #warning("shendy-note: let's fix setupDownloadPublsihers to setupDownloadPublishers")
    private func setupDownloadPublsihers(_ downloader: ObservableDownloader) -> [AnyCancellable] {
      var cancellables = [AnyCancellable]()

      downloader.requestSubject.share()
        .map { downloadRequest -> URLSessionDownloadTask in
          let task = downloader.session.downloadTask(with: downloadRequest.downloadSourceURL)
          task.resume()
          return task
        }
        .assign(to: \.task, on: downloader)
        .store(in: &cancellables)

      downloader.resumeDataSubject.map { resumeData in
        let task = downloader.session.downloadTask(withResumeData: resumeData)
        task.resume()
        return task
      }
      .assign(to: \.task, on: downloader)
      .store(in: &cancellables)

      return cancellables
    }

    private func setupByteUpdatPublishers(_ downloader: ObservableDownloader) -> [AnyCancellable] {
      var cancellables = [AnyCancellable]()
      let downloadUpdate = downloader.downloadUpdate.share()
      downloadUpdate
        .map(\.totalBytesWritten)
        .assign(to: \.totalBytesWritten, on: downloader)
        .store(in: &cancellables)
      downloadUpdate
        .map(\.totalBytesExpectedToWrite)
        .assign(to: \.totalBytesExpectedToWrite, on: downloader)
        .store(in: &cancellables)
      return cancellables
    }

    internal func callAsFunction(downloader: ObservableDownloader) -> [AnyCancellable] {
      var cancellables = [AnyCancellable]()

      let destinationFileURLPublisher = downloader.requestSubject.share().map(\.destinationFileURL)

      cancellables.append(contentsOf: setupDownloadPublsihers(downloader))

      Publishers.CombineLatest(downloader.locationURLSubject, destinationFileURLPublisher)
        .map { sourceURL, destinationURL in
          Result {
            try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
          }
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: downloader.onCompletion)
        .store(in: &cancellables)

      cancellables.append(contentsOf: setupByteUpdatPublishers(downloader))

      return cancellables
    }
  }
#endif
