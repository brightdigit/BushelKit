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
extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    var hexadecimal: Data? {
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
            let byteString = (self as NSString).substring(with: match!.range)
            let num = UInt8(byteString, radix: 16)!
            data.append(num)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    
}

struct SHA256 {
  internal init(data: Data) {
    self.data = data
  }
  
  internal init?(hexidecialString: String) {
    guard let data = hexidecialString.hexadecimal else {
      return nil
    }
    self.init(data: data)
  }
  
  let data : Data
}
struct RemoteImage {
  internal init(buildVersion: String, operatingSystemVersion: OperatingSystemVersion, url: URL, contentLength: Int, lastModified: Date, sha256: SHA256) {
    self.buildVersion = buildVersion
    self.operatingSystemVersion = operatingSystemVersion
    self.url = url
    self.contentLength = contentLength
    self.lastModified = lastModified
    self.sha256 = sha256
  }
  
  let buildVersion : String
  let operatingSystemVersion : OperatingSystemVersion
  let url : URL
  let contentLength : Int
  let lastModified: Date
  let sha256 : SHA256
  
  var size : String {
    let formatter = ByteCountFormatter()
    return formatter.string(from: .init(value: .init(self.contentLength), unit: .bytes))
    
  }
  
  static let lastModifiedDateFormatter : DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = $0
    return formatter
  }("E, d MMM yyyy HH:mm:ss Z")
}

extension RemoteImage {
  init  (vzRestoreImage : VZMacOSRestoreImage, headers : [AnyHashable : Any]) throws {
    guard let contentLength = headers["Content-Length"] as? Int else {
      throw NSError()
    }
    guard let lastModified = (headers["Last-Modified"] as? String).flatMap(Self.lastModifiedDateFormatter.date(from:)) else {
      throw NSError()
    }
    guard let sha256Hex = headers["x-amz-meta-digest-sha256"] as? String else {
      throw NSError()
    }
    guard let sha256 = SHA256(hexidecialString: sha256Hex) else {
      throw NSError()
    }
    self.init(buildVersion: vzRestoreImage.buildVersion, operatingSystemVersion: vzRestoreImage.operatingSystemVersion, url: vzRestoreImage.url,
              contentLength: contentLength, lastModified: lastModified, sha256: sha256)
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

    self.fetchLatestSupported{ result in
      let vzRestoreImage : VZMacOSRestoreImage
      switch result {
      case .success(let image):
        vzRestoreImage = image
      case .failure(let error):
        closure(.failure(error))
        return
      }
      var request = URLRequest(url: vzRestoreImage.url)
      request.httpMethod = "HEAD"
      URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error {
          closure(.failure(error))
          return
        }
        
        guard let response = response as? HTTPURLResponse else {
          closure(.failure(NSError()))
          return
        }

        let remoteImage : RemoteImage
        do {
          remoteImage = try .init(vzRestoreImage: vzRestoreImage, headers: response.allHeaderFields)
        } catch {
          closure(.failure(error))
          return
        }
        
        closure(.success(remoteImage))
      }.resume()
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
    closure(.success(.init(buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), url: .init(string: "https://apple.com")!, contentLength: 13837340777, lastModified: .init(), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!)))
  }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
      MainView().environmentObject(AppObject(remoteImageFetcher: Self.previewImageFetch(_:)))
    }
}
