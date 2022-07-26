import Foundation
import Virtualization

struct RestoreImageLibraryItemFile : Codable, Identifiable, Hashable, ImageContainer {
  func updatingWithURL(_ url: URL, andFileWrapper fileWrapper: FileWrapper?) -> RestoreImageLibraryItemFile {
    let fileAccessor : FileAccessor?
    
    if let fileWrapper = fileWrapper {
      fileAccessor = FileWrapperAccessor(fileWrapper: fileWrapper, url: url, sha256: self.metadata.sha256)
    } else if let oldFileAccessor = self.fileAccessor {
      fileAccessor = oldFileAccessor.updatingWithURL(url, sha256: self.metadata.sha256)
    } else {
      fileAccessor = nil
    }
    
    return RestoreImageLibraryItemFile(name: self.name, metadata: self.metadata.withURL(url), location: .library, fileAccessor: fileAccessor)
  }
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(metadata)
    hasher.combine(location)
    hasher.combine(installerType)
  }
  func installer() async throws -> ImageInstaller {
    return try await VZMacOSRestoreImage.loadFromURL(self.metadata.url)
  }
  
  static func == (lhs: RestoreImageLibraryItemFile, rhs: RestoreImageLibraryItemFile) -> Bool {
    lhs.id == rhs.id
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Self.CodingKeys)
    let name = try container.decode(String.self, forKey: .name)
    let metadata = try container.decode(ImageMetadata.self, forKey: .metadata)
    self.init(name: name, metadata: metadata, location: .library)
  }
  
  var id: Data {
    self.metadata.url.dataRepresentation
  }
  
  var name : String
  let metadata : ImageMetadata
  let location : RestoreImage.Location
  var fileAccessor : FileAccessor?
  let installerType : InstallerType = .vzMacOS
  
  enum CodingKeys : String, CodingKey {
    case name
    case metadata
    case installerType
  }
  
  init (name : String? = nil, metadata : ImageMetadata, location: RestoreImage.Location = .library, fileAccessor : FileAccessor? = nil) {
    self.name = name ?? metadata.url.deletingPathExtension().lastPathComponent
    self.metadata = metadata
    self.location = location
    self.fileAccessor = fileAccessor
  }
  
  
  init (restoreImage: RestoreImage) {
    self.init(metadata: restoreImage.metadata, location: restoreImage.location)
  }
}


extension RestoreImageLibraryItemFile {
  func forMachine () throws -> RestoreImageLibraryItemFile {
    guard let fileAccessor = self.fileAccessor else {
      throw NSError()
    }
    let temporaryFileURL = try fileAccessor.getURL()
    return RestoreImageLibraryItemFile(name: self.name, metadata: self.metadata.withURL(temporaryFileURL))
  }
}
