import Foundation
import Virtualization


struct RestoreImage : Identifiable, Hashable {
    internal init(name: String, remoteURL: URL?, localURL: URL?, buildVersion: String, operatingSystemVersion: OperatingSystemVersion, sha256: SHA256, contentLength: Int, lastModified: Date, restoreImage: VZMacOSRestoreImage?) {
        self.name = name
        self.remoteURL = remoteURL
        self.localURL = localURL
        self.buildVersion = buildVersion
        self.operatingSystemVersion = operatingSystemVersion
        self.sha256 = sha256
        self.restoreImage = restoreImage
        self.contentLength = contentLength
        self.lastModified = lastModified
    }
    
//    @available(*, deprecated)
//  internal init(name: String, url: URL, buildVersion: String, operatingSystemVersion: OperatingSystemVersion,
//                sha256: SHA256, restoreImage: VZMacOSRestoreImage?) {
//    self.name = name
//    self.localURL = url
//    self.buildVersion = buildVersion
//    self.operatingSystemVersion = operatingSystemVersion
//    self.sha256 = sha256
//    self.restoreImage = restoreImage
//      self.remoteURL = nil
//      fatalError()
//  }
  
  static func == (lhs: RestoreImage, rhs: RestoreImage) -> Bool {
    lhs.localURL == rhs.localURL
  }
  
  var name : String
  let remoteURL : URL?
  let localURL : URL?
  let buildVersion : String
  let operatingSystemVersion : OperatingSystemVersion
  let sha256 : SHA256
  let restoreImage: VZMacOSRestoreImage?
    let contentLength : Int
    let lastModified: Date
  
  var id: SHA256 {
      sha256
  }

  var mostFeaturefulSupportedConfiguration : VZMacOSConfigurationRequirements? {
    return self.restoreImage?.mostFeaturefulSupportedConfiguration
  }
  var isSupported : Bool? {
    self.mostFeaturefulSupportedConfiguration?.hardwareModel.isSupported
  }
  init (fromRemoteImage remoteImage: RestoreImage, at url: URL) {
      let name = remoteImage.name
    
      self.init(name: name, remoteURL: remoteImage.remoteURL, localURL: url, buildVersion: remoteImage.buildVersion, operatingSystemVersion: remoteImage.operatingSystemVersion,
                sha256: remoteImage.sha256, contentLength: remoteImage.contentLength, lastModified: remoteImage.lastModified,  restoreImage: remoteImage.restoreImage)
  }
      func localFileNameDownloadedAt(_ date: Date) -> String? {
          guard let url = self.remoteURL else {
              return nil
          }
        let pathExtension = url.pathExtension
        let lastPathComponent = url.deletingPathExtension().lastPathComponent
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return "\(lastPathComponent)[\(formatter.string(from: date))].\(pathExtension)"
      }
    //
    //  var size : String {
    //    let formatter = ByteCountFormatter()
    //    return formatter.string(from: .init(value: .init(self.contentLength), unit: .bytes))
    //
    //  }
    
    static let lastModifiedDateFormatter : DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = $0
      return formatter
    }("E, d MMM yyyy HH:mm:ss Z")
  
}

extension RestoreImage {
    static let previewModel : Self = .init(name: "Hello", remoteURL:  .init(string: "https://apple.com")!, localURL: nil, buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 1000000000, lastModified: .init(),  restoreImage: nil)
        //.init(name: "Hello", remoteURL: .init(string: "https://apple.com")!, buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, restoreImage: nil)
}

