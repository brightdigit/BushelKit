import Foundation
import Virtualization

protocol RestoreImageMetadataHardwareModel {
    var isSupported : Bool { get }
}
protocol RestoreImageMetadataConfiguration {
    associatedtype RestoreImageMetadataHardwareModelType : RestoreImageMetadataHardwareModel
    var hardwareModel : RestoreImageMetadataHardwareModelType { get }
}

protocol MachineConfigurationMetadata {
    
}
protocol RestoreImageMetadata : Hashable {
    associatedtype MachineConfigurationMetadataType : MachineConfigurationMetadata
    associatedtype RestoreImageMetadataConfigurationType : RestoreImageMetadataConfiguration
    var mostFeaturefulSupportedConfiguration : RestoreImageMetadataConfigurationType? { get }
    static func load(from fileURL: URL, completionHandler: @escaping (Result<Self, Error>) -> Void)
    func createMachineConfigurationMetadata(basedOnMachine machine: Machine<Self>) -> MachineConfigurationMetadataType
}
extension OperatingSystemVersion {
    static let anyImageName = [ "054-san-diego",
                                "055-california",
                                "056-castle",
                                "057-park"]
    static let bigSurImageNames = [        "058-climb",
                                           "059-mountains",
                                           "060-beach",
                                           "061-beach-1"]
    static let montereyImageNames = [
        "077-cheese",
        "078-cheese-1"]
    
    static let venturaImageNames = [
        "079-dog",
        "080-kitty"]
    var defaultImageName : String {
        switch self.majorVersion {
        case 11:
            return Self.bigSurImageNames.randomElement()!
        case 12:
            return Self.montereyImageNames.randomElement()!
        case 13:
            return Self.venturaImageNames.randomElement()!
        default:
            return Self.anyImageName.randomElement()!
        }
    }
}

struct RestoreImage<RestoreImageMetadataType : RestoreImageMetadata> : Identifiable, Hashable {
    internal init(name: String, imageName: String? = nil, remoteURL: URL?, localURL: URL?, buildVersion: String, operatingSystemVersion: OperatingSystemVersion, sha256: SHA256, contentLength: Int, lastModified: Date, restoreImage: RestoreImageMetadataType) {
        self.name = name
        self.remoteURL = remoteURL
        self.localURL = localURL
        self.buildVersion = buildVersion
        self.operatingSystemVersion = operatingSystemVersion
        self.imageName = imageName ?? operatingSystemVersion.defaultImageName
        self.sha256 = sha256
        self.restoreImage = restoreImage
        self.contentLength = contentLength
        self.lastModified = lastModified
    }
    
//    @available(*, deprecated)
//  internal init(name: String, url: URL, buildVersion: String, operatingSystemVersion: OperatingSystemVersion,
//                sha256: SHA256, restoreImage: VZMacOSRestoreImage?) {
//    self.name = name
//    self.localURL = url
//    self.buildVersion = buildVersion
//    self.operatingSystemVersion = operatingSystemVersion
//    self.sha256 = sha256
//    self.restoreImage = restoreImage
//      self.remoteURL = nil
//      fatalError()
//  }
  
  static func == (lhs: RestoreImage, rhs: RestoreImage) -> Bool {
    lhs.localURL == rhs.localURL
  }
    
    var isDownloaded: Bool {
        return self.localURL != nil
    }
  
  var name : String
    let imageName : String
  let remoteURL : URL?
  let localURL : URL?
  let buildVersion : String
  let operatingSystemVersion : OperatingSystemVersion
  let sha256 : SHA256
  let restoreImage: RestoreImageMetadataType
    let contentLength : Int
    let lastModified: Date
  
  var id: SHA256 {
      sha256
  }

    var mostFeaturefulSupportedConfiguration : RestoreImageMetadataType.RestoreImageMetadataConfigurationType? {
    return self.restoreImage.mostFeaturefulSupportedConfiguration
  }
  var isSupported : Bool {
    self.mostFeaturefulSupportedConfiguration?.hardwareModel.isSupported == true
  }
  init (fromRemoteImage remoteImage: RestoreImage, at url: URL) {
      let name = remoteImage.name
    
      self.init(name: name, remoteURL: remoteImage.remoteURL, localURL: url, buildVersion: remoteImage.buildVersion, operatingSystemVersion: remoteImage.operatingSystemVersion,
                sha256: remoteImage.sha256, contentLength: remoteImage.contentLength, lastModified: remoteImage.lastModified,  restoreImage: remoteImage.restoreImage)
  }
      func localFileNameDownloadedAt(_ date: Date) -> String? {
          guard let url = self.remoteURL else {
              return nil
          }
        let pathExtension = url.pathExtension
        let lastPathComponent = url.deletingPathExtension().lastPathComponent
        let formatter = DateFormatter()
        formatter.dateFormat = "yyMMddHHmmss"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return "\(lastPathComponent)[\(formatter.string(from: date))].\(pathExtension)"
      }
    //
    //  var size : String {
    //    let formatter = ByteCountFormatter()
    //    return formatter.string(from: .init(value: .init(self.contentLength), unit: .bytes))
    //
    //  }
    

  
}

extension URL {
    func localFileNameDownloadedAt(_ date: Date) -> String {
      let pathExtension = self.pathExtension
      let lastPathComponent = self.deletingPathExtension().lastPathComponent
      let formatter = DateFormatter()
      formatter.dateFormat = "yyMMddHHmmss"
      formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
      return "\(lastPathComponent)[\(formatter.string(from: date))].\(pathExtension)"
    }
}

enum Formatters {
    static let lastModifiedDateFormatter : DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = $0
      return formatter
    }("E, d MMM yyyy HH:mm:ss Z")
}

struct PreviewRestoreImageMetadataHardwareModel : RestoreImageMetadataHardwareModel, Hashable {
    let isSupported: Bool
}

struct PreviewRestoreImageMetadataConfiguration : RestoreImageMetadataConfiguration, Hashable {
    let hardwareModel: PreviewRestoreImageMetadataHardwareModel
    
    typealias RestoreImageMetadataHardwareModelType = PreviewRestoreImageMetadataHardwareModel
    
    
}

struct PreviewMachineConfigurationMetadata : MachineConfigurationMetadata {
    
}
struct PreviewRestoreImageMetadata : RestoreImageMetadata, Hashable {
    typealias MachineConfigurationMetadataType = PreviewMachineConfigurationMetadata
    
    
    
    static func load(from fileURL: URL, completionHandler: @escaping (Result<PreviewRestoreImageMetadata, Error>) -> Void) {
        
    }
    
    internal init(id: UUID = .init(), isSupported: Bool = true) {
        self.id = id
        self.mostFeaturefulSupportedConfiguration = .init(hardwareModel: .init(isSupported: isSupported))
    }
    
    static func == (lhs: PreviewRestoreImageMetadata, rhs: PreviewRestoreImageMetadata) -> Bool {
        return lhs.id == rhs.id
        
    }
    
    let id : UUID
    let mostFeaturefulSupportedConfiguration: PreviewRestoreImageMetadataConfiguration?
    
    typealias RestoreImageMetadataConfigurationType = PreviewRestoreImageMetadataConfiguration
    
    func createMachineConfigurationMetadata(basedOnMachine machine: Machine<PreviewRestoreImageMetadata>) -> PreviewMachineConfigurationMetadata {
        return PreviewMachineConfigurationMetadata()
    }
}

enum PreviewModel {
    
    static let previewRemoteModel : RestoreImage = .init(name: "Hello", remoteURL:  .init(string: "https://apple.com")!, localURL: nil, buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!, contentLength: 1000000000, lastModified: .init(),  restoreImage: PreviewRestoreImageMetadata())
}
