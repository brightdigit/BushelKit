import Foundation

import Virtualization

struct VirtualizationMacOSRestoreImage : ImageContainer {
  init(sha256: SHA256, contentLength: Int, lastModified: Date, vzRestoreImage: VZMacOSRestoreImage) {
    self.metadata = .init(sha256: sha256, contentLength: contentLength, lastModified: lastModified, vzRestoreImage: vzRestoreImage)
    self.vzRestoreImage = vzRestoreImage
  }
  
  let metadata: ImageMetadata
  
  
  
  
  let vzRestoreImage : VZMacOSRestoreImage
  
  
  func installer() async throws -> ImageInstaller {
    return self.vzRestoreImage
  }
  
  init  (vzRestoreImage : VZMacOSRestoreImage, sha256 : SHA256?) async throws {
    if vzRestoreImage.url.isFileURL {
      let attrs = try FileManager.default.attributesOfItem(atPath: vzRestoreImage.url.path)
      guard let contentLength : Int = attrs[.size] as? Int, let lastModified = attrs[.modificationDate] as? Date else {
        throw NSError()
      }
      let sha256Value : SHA256
      if let sha256Arg = sha256 {
        sha256Value = sha256Arg
      } else {
        sha256Value = try await SHA256(fileURL: vzRestoreImage.url)
      }
      self.init(sha256: sha256Value, contentLength: contentLength, lastModified: lastModified, vzRestoreImage: vzRestoreImage)
    } else {
      let headers = try await vzRestoreImage.headers()
      try self.init(vzRestoreImage: vzRestoreImage, headers: headers)
    }
  }
  init  (vzRestoreImage : VZMacOSRestoreImage, headers : [AnyHashable : Any]) throws {
    guard let contentLengthString = headers["Content-Length"] as? String else {
      throw MissingError.needDefinition((headers,"Content-Lenght"))
    }
    guard let contentLength = Int(contentLengthString) else {
      throw MissingError.needDefinition((headers,"Content-Lenght"))
    }
    guard let lastModified = (headers["Last-Modified"] as? String).flatMap(Formatters.lastModifiedDateFormatter.date(from:)) else {
      
      throw MissingError.needDefinition((headers,"Last-Modified"))
    }
    guard let sha256Hex = headers["x-amz-meta-digest-sha256"] as? String else {
      
      throw MissingError.needDefinition((headers,"x-amz-meta-digest-sha256"))
    }
    guard let sha256 = SHA256(hexidecialString: sha256Hex) else {
      throw MissingError.needDefinition((headers,"x-amz-meta-digest-sha256"))
    }
    
    
    self.init(sha256: sha256, contentLength: contentLength, lastModified: lastModified, vzRestoreImage: vzRestoreImage)
  }
  //headers : [AnyHashable : Any]
}
