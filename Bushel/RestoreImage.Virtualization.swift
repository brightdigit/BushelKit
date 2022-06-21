import Foundation
import Virtualization

extension VZMacOSRestoreImage {
    var name : String {
        return "macOS \(self.operatingSystemVersion) \(self.buildVersion)"
    }
}
extension RestoreImage {
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
        
        let isSupported = vzRestoreImage.mostFeaturefulSupportedConfiguration?.hardwareModel.isSupported ?? false
        
        self.init(name: vzRestoreImage.name, remoteURL: vzRestoreImage.url, localURL: nil, buildVersion: vzRestoreImage.buildVersion, operatingSystemVersion: vzRestoreImage.operatingSystemVersion, sha256: sha256, contentLength: contentLength, lastModified: lastModified, restoreImage: vzRestoreImage)
    }
}
