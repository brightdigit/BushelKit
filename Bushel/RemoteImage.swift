//import Foundation
//import Virtualization
//
//@available(*, deprecated)
//struct RemoteImage {
//  internal init(buildVersion: String, operatingSystemVersion: OperatingSystemVersion, url: URL, contentLength: Int, lastModified: Date, sha256: SHA256, restoreImage : VZMacOSRestoreImage?) {
//    self.buildVersion = buildVersion
//    self.operatingSystemVersion = operatingSystemVersion
//    self.url = url
//    self.contentLength = contentLength
//    self.lastModified = lastModified
//    self.sha256 = sha256
//    self.restoreImage = restoreImage
//  }
//  
//  let buildVersion : String
//  let operatingSystemVersion : OperatingSystemVersion
//  let url : URL
//  let contentLength : Int
//  let lastModified: Date
//  let sha256 : SHA256
//  let restoreImage : VZMacOSRestoreImage?
//  
//  func localFileNameDownloadedAt(_ date: Date) -> String {
//    let pathExtension = url.pathExtension
//    let lastPathComponent = url.deletingPathExtension().lastPathComponent
//    let formatter = DateFormatter()
//    formatter.dateFormat = "yyMMddHHmmss"
//    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
//    return "\(lastPathComponent)[\(formatter.string(from: date))].\(pathExtension)"
//  }
//  
//  var size : String {
//    let formatter = ByteCountFormatter()
//    return formatter.string(from: .init(value: .init(self.contentLength), unit: .bytes))
//    
//  }
//  
//}
//
//
//extension RemoteImage {
//  static let previewModel : Self = .init(buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), url: .init(string: "https://apple.com")!, contentLength: 13837340777, lastModified: .init(), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, restoreImage: nil)
//}
