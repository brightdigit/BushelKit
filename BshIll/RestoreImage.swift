import Foundation

struct RestoreImage : Identifiable, Hashable {
  static func == (lhs: RestoreImage, rhs: RestoreImage) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
  
  
  
  let id : UUID = UUID()
  
  //    let isSupported : Bool
  //    let buildVersion : String
  //    let operatingSystemVersion : OperatingSystemVersion
  //    let sha256 : SHA256
  //      let contentLength : Int
  //    let lastModified: Date
  
  let installer : () async throws -> ImageInstaller
  let metadata : ImageMetadata
  init(metadata : ImageMetadata, installer: @escaping () async throws -> ImageInstaller) {
    self.metadata = metadata
    self.installer = installer
  }
  
  init(imageContainer: ImageContainer) {
    self.init(metadata: imageContainer.metadata, installer: imageContainer.installer)
  }
  
}

extension RestoreImage {
  
  enum Location {
    case library
    case local
    case remote
    case reloaded
  }
  var location : Location {
    let url = self.metadata.url
    if url.isFileURL == true {
#warning("fix to allow subfolders under `Restore Images`")
      let directoryURL = url.deletingLastPathComponent()
      guard directoryURL.lastPathComponent == "Restore Images"  else {
        return .local
      }
      guard directoryURL.deletingLastPathComponent().pathExtension == "bshrilib" else {
        return .local
      }
      return .library
    } else {
      return .remote
    }
  }
}

extension RestoreImage {
  
  enum Previews {
    // ImageMetadata(isImageSupported: true, buildVersion: "true", operatingSystemVersion: OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0, sha256: SHA256(base64Encoded: "LbNHYPVKVKpwXUmqZInQ1Nr9gaYni4IKjelvzpl72LI=")!, contentLength: 0, lastModified: 2022-07-09 21:15:44 +0000, url: file:///var/folders/5d/8rl1m9ts5r96dxdh4rp_zx100000gn/T/com.brightdigit.BshIll/B6844821-A5C8-42B5-80C2-20F815FB920E.ipsw
    static func  usingMetadata(_ metadata: ImageMetadata) -> RestoreImage {
      .init(metadata: metadata, installer: {MockInstaller()})
    }
  }
}
