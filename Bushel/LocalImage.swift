import Foundation


struct LocalImage : Codable, Identifiable, Hashable {
  internal init(name: String, url: URL, buildVersion: String, operatingSystemVersion: OperatingSystemVersion,
                sha256: SHA256, isSupported: Bool) {
    self.name = name
    self.url = url
    self.buildVersion = buildVersion
    self.operatingSystemVersion = operatingSystemVersion
    self.sha256 = sha256
    self.isSupported = isSupported
  }
  
  static func == (lhs: LocalImage, rhs: LocalImage) -> Bool {
    lhs.url == rhs.url
  }
  
  var name : String
  let url : URL
  let buildVersion : String
  let operatingSystemVersion : OperatingSystemVersion
  let sha256 : SHA256
  let isSupported: Bool
  
  var id: URL {
    url
  }
  
  init (fromRemoteImage remoteImage: RemoteImage, at url: URL) {
    let name = remoteImage.url.deletingPathExtension().lastPathComponent
    
    self.init(name: name, url: url, buildVersion: remoteImage.buildVersion, operatingSystemVersion: remoteImage.operatingSystemVersion,
              sha256: remoteImage.sha256, isSupported: remoteImage.isSupported)
  }
}

extension LocalImage {
  static let previewModel : Self = .init(name: "Hello", url: .init(string: "https://apple.com")!, buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, isSupported: true)
}
