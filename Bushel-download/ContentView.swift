//
//  ContentView.swift
//  Bushel-download
//
//  Created by Leo Dion on 5/26/22.
//

import SwiftUI
import Combine

let downloadURL = URL(string: "https://speed.hetzner.de/100MB.bin")!


class Downloader : NSObject, ObservableObject, URLSessionDownloadDelegate {
  @Published var totalBytesWritten: Int64 = 0
  @Published var totalBytesExpectedToWrite: Int64?
  @Published var isCompleted: Result<Void,Error>?
  let destinationURLSubject = PassthroughSubject<URL, Never>()
  let locationURLSubject = PassthroughSubject<URL, Never>()
  
  internal init(downloadURL: URL, configuration: URLSessionConfiguration?, queue: OperationQueue?) {
    self.downloadURL = downloadURL
    
    super.init()
    
    
    self.locationURLSubject.combineLatest(self.destinationURLSubject).map { (sourceURL, destinationURL) in
      Result {
        try FileManager.default.moveItem(at: sourceURL, to: destinationURL)
      }
    }.receive(on: DispatchQueue.main).assign(to: &self.$isCompleted)
    
    self.cancellable = self.destinationURLSubject.share().sink { _ in
      self.task.resume()
    }
    
    let session = URLSession(configuration: configuration ?? .default, delegate: self, delegateQueue: queue)
    self.task = session.downloadTask(with: downloadURL)
    self.session = session
    
    
  }
  
  let downloadURL : URL
  var task : URLSessionDownloadTask!
  var session : URLSession!
  var cancellable : AnyCancellable!
  
  
  func begin (to destinationURL : URL) {
    destinationURLSubject.send(destinationURL)
    task.resume()
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



struct ContentView: View {
  @StateObject var downloader = Downloader(downloadURL: downloadURL, configuration: nil, queue: nil)
  //@State var total : Int64?
  //@State var written : Int64 = 0
  func startDownload (to url: URL) {
    self.downloader.begin(to: url)

  }
    var body: some View {
      VStack{
        Button("Save Location") {
          let panel = NSSavePanel()
          panel.begin { response in
            guard let url = panel.url, response == .OK else {
              return
            }
            
            self.startDownload(to: url)
          }
        }
        self.downloader.totalBytesExpectedToWrite.map { total in
          
              ProgressView(
                "Downloading",
                value: Float(self.downloader.totalBytesWritten),
                total:  Float(total)
              )
        }
          
          
        
      }
      .padding()
//      .onReceive(self.downloader.$totalBytesExpectedToWrite) { total in
//        self.total = total
//      }
//      .onReceive(self.downloader.$totalBytesWritten) { written in
//        self.written = written
//      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
