import Foundation


struct LocalImage : Codable, Identifiable, Hashable {
  internal init(name: String, url: URL, buildVersion: String, operatingSystemVersion: OperatingSystemVersion,
                sha256: SHA256) {
    self.name = name
    self.url = url
    self.buildVersion = buildVersion
    self.operatingSystemVersion = operatingSystemVersion
    self.sha256 = sha256
  }
  
  static func == (lhs: LocalImage, rhs: LocalImage) -> Bool {
    lhs.url == rhs.url
  }
  
  var name : String
  let url : URL
  let buildVersion : String
  let operatingSystemVersion : OperatingSystemVersion
  let sha256 : SHA256
  
  var id: URL {
    url
  }
  
  init (fromRemoteImage remoteImage: RemoteImage, at url: URL) {
    let name = remoteImage.url.deletingPathExtension().lastPathComponent
    
    self.init(name: name, url: url, buildVersion: remoteImage.buildVersion, operatingSystemVersion: remoteImage.operatingSystemVersion,
              sha256: remoteImage.sha256)
  }
}
