import Foundation

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
  
  func localFileNameDownloadedAt(_ date: Date) -> String {
    let pathExtension = url.pathExtension
    let lastPathComponent = url.deletingPathExtension().lastPathComponent
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMddHHmmss"
    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    return "\(lastPathComponent)[\(formatter.string(from: date))].\(pathExtension)"
  }
  
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
