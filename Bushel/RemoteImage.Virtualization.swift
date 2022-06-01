import Foundation
import Virtualization

extension RemoteImage {
  init  (vzRestoreImage : VZMacOSRestoreImage, headers : [AnyHashable : Any]) throws {
    guard let contentLengthString = headers["Content-Length"] as? String else {
      throw NSError()
    }
    guard let contentLength = Int(contentLengthString) else {
      throw NSError()
    }
    guard let lastModified = (headers["Last-Modified"] as? String).flatMap(Self.lastModifiedDateFormatter.date(from:)) else {
      throw NSError()
    }
    guard let sha256Hex = headers["x-amz-meta-digest-sha256"] as? String else {
      throw NSError()
    }
    guard let sha256 = SHA256(hexidecialString: sha256Hex) else {
      throw NSError()
    }
    self.init(buildVersion: vzRestoreImage.buildVersion, operatingSystemVersion: vzRestoreImage.operatingSystemVersion, url: vzRestoreImage.url,
              contentLength: contentLength, lastModified: lastModified, sha256: sha256)
  }
}
