import Virtualization


extension LocalImage {
  
  init (fromLocalImage image: VZMacOSRestoreImage, at url: URL) throws {
    let configuration = image.mostFeaturefulSupportedConfiguration
    let hardware : VZMacHardwareModel? = configuration?.hardwareModel
    let isSupported = hardware?.isSupported ?? false
    let name = url.deletingPathExtension().lastPathComponent
    let sha256Data = try Bushel.sha256(url: url)
    
    self.init(name: name, url: url, buildVersion: image.buildVersion, operatingSystemVersion: image.operatingSystemVersion, sha256: .init(data: sha256Data), restoreImage: image)
  }
}
