import Virtualization


extension LocalImage {
  
  init (fromLocalImage image: VZMacOSRestoreImage, at url: URL) throws {
    let name = url.deletingPathExtension().lastPathComponent
    let sha256Data = try Bushel.sha256(url: url)
    
    self.init(name: name, url: url, buildVersion: image.buildVersion, operatingSystemVersion: image.operatingSystemVersion, sha256: .init(data: sha256Data))
  }
}
