//
//  MainView.swift
//  Bushel
//
//  Created by Leo Dion on 5/27/22.
//

import SwiftUI
import Virtualization
import Combine


struct LocalImage : Codable, Identifiable, Hashable {
  static func == (lhs: LocalImage, rhs: LocalImage) -> Bool {
    lhs.url == rhs.url
  }
  
  var name : String
  let url : URL
  let buildVersion : String
  let operatingSystemVersion : OperatingSystemVersion
  
  var id: URL {
    url
  }
}
struct Configuration : Codable {
  let images : [LocalImage]
}

struct RemoteImage {
  let buildVersion : String
  let operatingSystemVersion : OperatingSystemVersion
  let url : URL
}

extension RemoteImage {
  init (vzRestoreImage : VZMacOSRestoreImage) {
    self.init(buildVersion: vzRestoreImage.buildVersion, operatingSystemVersion: vzRestoreImage.operatingSystemVersion, url: vzRestoreImage.url)
  }
}

extension RemoteImage {
  static func publisher(from fetch: @escaping  RemoteImageFetcher) -> AnyPublisher<Result<RemoteImage, Error>, Never> {
    return Future { fulfill in
      fetch{
        fulfill(.success($0))
      }
    }.eraseToAnyPublisher()
  }
}

typealias RemoteImageFetcher = (@escaping (Result<RemoteImage,Error>) -> Void) -> Void

extension VZMacOSRestoreImage {
  static func remoteImageFetch (_ closure: @escaping (Result<RemoteImage,Error>) -> Void) {
    self.fetchLatestSupported{
      closure($0.map(RemoteImage.init))
    }
  }
}
class AppObject : ObservableObject {
  @Published var remoteImage : RemoteImage?
  @Published var images : [LocalImage] = .init()
  
  let remoteImageFetcher : RemoteImageFetcher

  let refreshTriggerSubject  = PassthroughSubject<Void, Never>()
  
  init (remoteImageFetcher : RemoteImageFetcher?) {
    self.remoteImageFetcher = remoteImageFetcher ?? VZMacOSRestoreImage.remoteImageFetch
    
    self.refreshTriggerSubject.flatMap{
      RemoteImage.publisher(from: self.remoteImageFetcher)
    }.compactMap{
      try? $0.get()
    }.receive(on: DispatchQueue.main)
      .assign(to: &self.$remoteImage)
  }
  
  func initialize() {
    if remoteImage == nil {
      self.refreshTriggerSubject.send()
    }
  }
  
  func beginDownloadingRemoteImage(_ image: RemoteImage) {
    
  }
}


struct MainView: View {
  @State var selectedImage : LocalImage? 
  @EnvironmentObject var object : AppObject
    var body: some View {
      TabView {
        VStack {
          RemoteImageView(image: object.remoteImage).border(.secondary)
          ImageList(images: object.images, imageBinding: self.$selectedImage)
        }.tabItem {
          
          Label("Images", systemImage:  "externaldrive.fill")
        
      }.onAppear(perform: object.initialize)
      }.frame(width: 400.0)
    }
}

extension PreviewProvider {
  static func previewImageFetch (_ closure: @escaping (Result<RemoteImage,Error>) -> Void) {
    closure(.success(.init(buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), url: .init(string: "https://apple.com")!)))
  }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
      MainView().environmentObject(AppObject(remoteImageFetcher: Self.previewImageFetch(_:)))
    }
}
