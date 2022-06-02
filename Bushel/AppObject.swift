import Combine
import Foundation
import Virtualization
class AppObject : ObservableObject {
  var cancellables = [AnyCancellable]()
  @Published var remoteImage : RemoteImage?
  @Published var images : [LocalImage] = .init()
  
  let applicationSupportDirectoryURL : URL
  let imagesDirectory : URL
  let machinesDirectory : URL
  let remoteImageFetcher : RemoteImageFetcher

  let refreshTriggerSubject  = PassthroughSubject<Void, Never>()
  
  init (remoteImageFetcher : RemoteImageFetcher?) {
    #warning("don't mention `VZMacOSRestoreImage`")
    self.remoteImageFetcher = remoteImageFetcher ?? VZMacOSRestoreImage.remoteImageFetch
    
    self.applicationSupportDirectoryURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    self.imagesDirectory = applicationSupportDirectoryURL.appendingPathComponent("images", isDirectory: true)
    self.machinesDirectory = applicationSupportDirectoryURL.appendingPathComponent("machines", isDirectory: true)
    
    self.refreshTriggerSubject.flatMap{
      RemoteImage.publisher(from: self.remoteImageFetcher)
    }.compactMap{
      try? $0.get()
    }.receive(on: DispatchQueue.main)
      .assign(to: &self.$remoteImage)
    
    
  }
  
  func initialize()  {
    if remoteImage == nil {
      self.refreshTriggerSubject.send()
    }
    
      try! FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
    try! FileManager.default.createDirectory(at: machinesDirectory, withIntermediateDirectories: true)
  }
  
  func beginDownloadingRemoteImage(_ image: RemoteImage, with downloader: Downloader) throws {
    let destinationURL = imagesDirectory.appendingPathComponent( image.localFileNameDownloadedAt(.init()))
    
    
      downloader.$isCompleted.compactMap {
        try? $0?.get()
      }.map {
        LocalImage(fromRemoteImage: image, at: destinationURL)
      }.sink { localImage in
        self.images.append(localImage)
      }.store(in: &self.cancellables)
    downloader.begin(from: image.url, to: destinationURL)
  }
  
  func loadImage(from url: URL, _ completed: @escaping (Error?) -> Void) {
    #warning("don't mention `VZMacOSRestoreImage` and use closure")
    VZMacOSRestoreImage.load(from: url) { result in
      
      let newResult = result.flatMap { image -> Result<LocalImage, Error> in
        let newURL = self.imagesDirectory.appendingPathComponent(image.localFileNameDownloadedAt(.init()))
         return .init{
            try FileManager.default.copyItem(at: url, to: newURL)
            return try LocalImage(fromLocalImage: image, at: newURL)
          }
      }
      switch newResult {
      case .failure(let error):
        completed(error)
        return
      case .success(let image):
        DispatchQueue.main.async {
          self.images.append(image)
        }
        
      }
    }
  }
}
