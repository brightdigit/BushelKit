import Combine
import Foundation
import Virtualization
class AppObject<RestoreImageMetadataType: RestoreImageMetadata> : ObservableObject {
  var cancellables = [AnyCancellable]()
  //@Published var remoteImage : RemoteImage?
  @Published var images : [RestoreImage<RestoreImageMetadataType>] = .init()
  
  let applicationSupportDirectoryURL : URL
  let imagesDirectory : URL
  let machinesDirectory : URL
  let remoteImageFetcher : RemoteRestoreImageFetcher<RestoreImageMetadataType>

  let refreshTriggerSubject  = PassthroughSubject<Void, Never>()
  
    init (remoteImageFetcher : @escaping RemoteRestoreImageFetcher<RestoreImageMetadataType>) {
    #warning("don't mention `VZMacOSRestoreImage`")
    self.remoteImageFetcher = remoteImageFetcher
    
    self.applicationSupportDirectoryURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    self.imagesDirectory = applicationSupportDirectoryURL.appendingPathComponent("images", isDirectory: true)
    self.machinesDirectory = applicationSupportDirectoryURL.appendingPathComponent("machines", isDirectory: true)
    
      self.refreshTriggerSubject.flatMap{
      RestoreImage.publisher(from: self.remoteImageFetcher)
    }.compactMap{
      try? $0.get()
    }.receive(on: DispatchQueue.main).sink(
        receiveValue: self.addImage(_:)).store(in: &self.cancellables)
    
    
  }
    
    func addImage (_ image: RestoreImage<RestoreImageMetadataType>) {
        self.images.append(image)
        self.images.sort { lhs, rhs in
            return lhs.remoteURL != nil
        }
    }
  
  func initialize()  {
      if images.isEmpty {
      self.refreshTriggerSubject.send()
    }
    
      try! FileManager.default.createDirectory(at: imagesDirectory, withIntermediateDirectories: true)
    try! FileManager.default.createDirectory(at: machinesDirectory, withIntermediateDirectories: true)
  }
  
  func beginDownloadingRemoteImage(_ image: RestoreImage<RestoreImageMetadataType>, with downloader: Downloader) throws {
      guard let localName = image.localFileNameDownloadedAt(.init()) else {
          return
      }
      guard let remoteURL = image.remoteURL else {
          return
      }
      let destinationURL = imagesDirectory.appendingPathComponent(localName )
    
    
      downloader.$isCompleted.compactMap {
        try? $0?.get()
      }.map {
        RestoreImage(fromRemoteImage: image, at: destinationURL)
      }.sink { localImage in
        self.images.append(localImage)
      }.store(in: &self.cancellables)
    downloader.begin(from: remoteURL, to: destinationURL)
  }
    
    
  
  func loadImage(from url: URL, _ completed: @escaping (Error?) -> Void) {
 
      RestoreImageMetadataType.load(from: url) { result in
      
      let newResult = result.flatMap { image -> Result<RestoreImage<RestoreImageMetadataType>, Error> in
        let newURL = self.imagesDirectory.appendingPathComponent(url.localFileNameDownloadedAt(.init()))
         return .init{
            try FileManager.default.copyItem(at: url, to: newURL)
            return try RestoreImage(fromLocalImage: image, at: newURL)
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
