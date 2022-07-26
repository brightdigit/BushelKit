import Foundation
import Virtualization

struct ImageMetadata : Codable, CustomDebugStringConvertible, Hashable {
  internal init(isImageSupported: Bool, buildVersion: String, operatingSystemVersion: OperatingSystemVersion, sha256: SHA256, contentLength: Int, lastModified: Date, url: URL) {
    self.isImageSupported = isImageSupported
    self.buildVersion = buildVersion
    self.operatingSystemVersion = operatingSystemVersion
    self.sha256 = sha256
    self.contentLength = contentLength
    self.lastModified = lastModified
    self.url = url
  }
  
  let isImageSupported : Bool
  let buildVersion : String
  let operatingSystemVersion : OperatingSystemVersion
  let sha256 : SHA256
  let contentLength : Int
  let lastModified: Date
  let url : URL
  
  var debugDescription: String {
    
    "\(Self.self)(isImageSupported: \(self.isImageSupported), buildVersion: \"\(self.buildVersion)\", operatingSystemVersion: \(self.operatingSystemVersion.debugDescription), sha256: \(self.sha256.debugDescription), contentLength: \(self.contentLength), lastModified: Date(timeIntervalSinceReferenceDate: \(self.lastModified.timeIntervalSinceReferenceDate)), url: \(self.url.debugDescription)"
  }
}


extension ImageMetadata{
  init (sha256: SHA256, contentLength: Int, lastModified: Date, vzRestoreImage: VZMacOSRestoreImage) {
    self.init(isImageSupported: vzRestoreImage.isImageSupported, buildVersion: vzRestoreImage.buildVersion, operatingSystemVersion: vzRestoreImage.operatingSystemVersion, sha256: sha256, contentLength: contentLength, lastModified: lastModified, url: vzRestoreImage.url)
  }
  
  func withURL(_ url: URL) -> ImageMetadata {
    return ImageMetadata(isImageSupported: self.isImageSupported, buildVersion: self.buildVersion, operatingSystemVersion: self.operatingSystemVersion, sha256: self.sha256, contentLength: self.contentLength, lastModified: self.lastModified, url: url)
  }
}


extension ImageMetadata {
  enum Previews {
    //static let previewModel : ImageMetadata = .init(url: URL(string: "https://updates.cdn-apple.com/2022SummerSeed/fullrestores/012-30346/9DD787A7-044B-4650-86D4-84E80B6B9C36/UniversalMac_13.0_22A5286j_Restore.ipsw")!, isImageSupported: true, buildVersion: "12312SA", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 0, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 16000000000, lastModified: Date())
    static let previewModel : ImageMetadata = .init(isImageSupported: true, buildVersion: "12312SA", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 0, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 16000000000, lastModified: .init(), url: URL(string: "https://updates.cdn-apple.com/2022SummerSeed/fullrestores/012-30346/9DD787A7-044B-4650-86D4-84E80B6B9C36/UniversalMac_13.0_22A5286j_Restore.ipsw")!)
    
    static let venturaBeta3 = ImageMetadata(isImageSupported: true, buildVersion: "22A5295h", operatingSystemVersion: OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0), sha256: SHA256(base64Encoded: "LbNHYPVKVKpwXUmqZInQ1Nr9gaYni4IKjelvzpl72LI=")!, contentLength: 0, lastModified: Date(timeIntervalSinceReferenceDate: 679094144.0), url: URL(string: "file:///var/folders/5d/8rl1m9ts5r96dxdh4rp_zx100000gn/T/com.brightdigit.BshIll/B6844821-A5C8-42B5-80C2-20F815FB920E.ipsw")!)
    
    static let monterey = ImageMetadata(isImageSupported: true, buildVersion: "21F79", operatingSystemVersion: OperatingSystemVersion(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: SHA256(base64Encoded: "H56SH3e7y1z3gCY4nW9zMc3WdbwIH/rHf8AEBafoIrM=")!, contentLength: 0, lastModified: Date(timeIntervalSinceReferenceDate: 679276356.959953), url: URL(string: "file:///var/folders/_z/7dqmnmzj0k1_57ctrgqrdq840000gn/T/com.brightdigit.BshIll/D0FB9B1B-0ED1-4721-AD0D-8A81C08A5ED2.ipsw")!)
  }
}
