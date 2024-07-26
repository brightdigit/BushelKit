//
//  SetupPublishers.swift
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

#if canImport(Combine)
  public import Combine

  public import Foundation

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
