//
//  Downloader.swift
//  Bushel
//
//  Created by Leo Dion on 5/29/22.
//

import Foundation
import Combine


class Downloader : NSObject, ObservableObject, URLSessionDownloadDelegate {
  struct DownloadRequest {
    let downloadSourceURL : URL
    let destinationFileURL : URL
  }
  @Published var totalBytesWritten: Int64 = 0
  @Published var totalBytesExpectedToWrite: Int64?
  @Published var isCompleted: Result<Void,Error>?
  //let downloadURL : URL
  var task : URLSessionDownloadTask?
  var session : URLSession!
  var cancellable : AnyCancellable?
  let requestSubject = PassthroughSubject<DownloadRequest, Never>()
  let locationURLSubject = PassthroughSubject<URL, Never>()
  
    let formatter = ByteCountFormatter()
  
  var prettyBytesWritten : String {
    
    return formatter.string(from: .init(value: .init(self.totalBytesWritten), unit: .bytes))
  }
  var prettyBytesTotal  : String? {
    self.totalBytesExpectedToWrite.map{
      formatter.string(from: .init(value: .init($0), unit: .bytes))
    }
  }
  
  var percentCompleted : Float? {
    self.totalBytesExpectedToWrite.map{
      Float((self.totalBytesWritten * 10000) / $0) / 100.0
    }
  }
  var isActive : Bool {
    isCompleted == nil && task != nil
  }
  
  internal init(configuration: URLSessionConfiguration? = nil, queue: OperationQueue? = nil) {
    //self.downloadURL = downloadURL
    
    super.init()
    let session = URLSession(configuration: configuration ?? .default, delegate: self, delegateQueue: queue)
    
    self.session = session
    
    
    let destinationFileURLPublisher = self.requestSubject.share().map{$0.destinationFileURL}
    self.cancellable = self.requestSubject.share().map { downloadRequest -> URLSessionDownloadTask in
      let task = self.session.downloadTask(with: downloadRequest.downloadSourceURL)
      task.resume()
      return task
    }.assign(to: \.task, on:  self)
    Publishers.CombineLatest(self.locationURLSubject, destinationFileURLPublisher).map { (sourceURL, destinationURL) in
      Result {
        try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
      }
    }.receive(on: DispatchQueue.main).assign(to: &self.$isCompleted)
    
   
    //self.session = session
    
    
  }
  
  
  func cancel () {
    self.task?.cancel()
  }
  
  
  func begin (from downloadSourceURL: URL, to destinationFileURL : URL) {
    self.requestSubject.send(.init(downloadSourceURL: downloadSourceURL, destinationFileURL: destinationFileURL))
    //task.resume()
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    
    self.locationURLSubject.send(location)
    
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    
      DispatchQueue.main.async {
        self.totalBytesWritten = totalBytesWritten
        self.totalBytesExpectedToWrite = totalBytesExpectedToWrite
        print(Float(totalBytesWritten), Float(totalBytesExpectedToWrite))
      }
  }
}
