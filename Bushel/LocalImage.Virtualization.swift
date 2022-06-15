import Virtualization


extension RestoreImage {
  
  init (fromLocalImage image: VZMacOSRestoreImage, at url: URL) throws {
    let configuration = image.mostFeaturefulSupportedConfiguration
    let hardware : VZMacHardwareModel? = configuration?.hardwareModel
    let isSupported = hardware?.isSupported ?? false
    let name = url.deletingPathExtension().lastPathComponent
    let sha256Data = try Bushel.sha256(url: url)
    
      let attr = try FileManager.default.attributesOfItem(atPath: url.path)
      guard let size64 = attr[FileAttributeKey.size] as? UInt64 else {
          throw NSError()
      }
      guard let lastModified = attr[FileAttributeKey.modificationDate] as? Date else {
          throw NSError()
      }
      
      
      self.init(name: name, remoteURL: nil, localURL: url, buildVersion: image.buildVersion, operatingSystemVersion: image.operatingSystemVersion, sha256: .init(data: sha256Data), contentLength: .init(size64), lastModified: lastModified, restoreImage: image)
    //self.init(name: name, url: url, buildVersion: image.buildVersion, operatingSystemVersion: image.operatingSystemVersion, sha256: .init(data: sha256Data), restoreImage: image)
  }
}
