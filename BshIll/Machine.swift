import Foundation
import Virtualization

struct Machine : Identifiable, Codable {
  internal init(id: UUID = .init(), restoreImage: RestoreImageLibraryItemFile? = nil, operatingSystem: OperatingSystemDetails? = nil) {
    self.id = id
    self.restoreImage = restoreImage
    self.operatingSystem = operatingSystem
  }
  
  let id : UUID
  var restoreImage : RestoreImageLibraryItemFile?
  var operatingSystem : OperatingSystemDetails?
  var configurationURL: URL?
  var fileAccessor : FileAccessor?
  
  func createMachine () throws -> MachineSession {
    guard self.operatingSystem?.type == .macOS else {
      throw NSError()
    }
    guard let url = self.configurationURL else {
      throw NSError()
    }
    let configuration = try VZVirtualMachineConfiguration(contentsOfDirectory: url)
    try configuration.validate()
    return VZVirtualMachine(configuration: configuration)
    
  }
  //var fileWrapper : FileWrapper?
  var isBuilt : Bool {
    guard operatingSystem != nil else {
      return false
    }
    
    guard let installerType = restoreImage?.installerType else {
      return false
    }
    
    guard let configurationURL = configurationURL else {
      return false
    }
//    guard let fileWrapper = self.fileWrapper else {
//      return false
//    }
    
    return installerType.validateAt(configurationURL)
  }
  
  enum CodingKeys : String, CodingKey {
    case id
    case restoreImage
    case configurationURL
    case operatingSystem
  }
  
  mutating func setConfiguration(_ configuration: MachineConfiguration) {
    self.configurationURL = configuration.currentURL
  }
  
  mutating func osInstallationCompleted (withConfiguration configuration: MachineConfiguration) {
    guard let metadata = self.restoreImage?.metadata else {
      return
    }
    self.setConfiguration(configuration)
    self.operatingSystem = .init(type: .macOS, version: metadata.operatingSystemVersion, buildVersion: metadata.buildVersion)
  }
  
  mutating func beginLoadingFromURL(_ url: URL) {
    self.configurationURL = url
    
    
  }
  //var configuration : MachineConfiguration?
  //var installer : ImageInstaller?
}

extension Machine {
  func createInstaller () async throws -> ImageInstaller {
    guard let restoreImage = self.restoreImage else {
      throw NSError()
    }
    return try await restoreImage.installer()
  }
  func build (withInstaller installer: ImageInstaller)  throws  -> MachineConfiguration {
    
      return try installer.setupMachine(self)
    
  }
  
  func startInstallation (with installer: ImageInstaller, using configuration: MachineConfiguration) throws -> VirtualInstaller {
   
      return try installer.beginInstaller(configuration: configuration)
    
  }
}
