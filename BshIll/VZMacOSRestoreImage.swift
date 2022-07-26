
import Virtualization
import Combine



extension VZMacOSRestoreImage {
  var isImageSupported: Bool {
#if swift(>=5.7)
    if #available(macOS 13.0, *) {
      return self.isSupported
    } else {
      return self.mostFeaturefulSupportedConfiguration?.hardwareModel.isSupported == true
    }
#else
    return self.mostFeaturefulSupportedConfiguration?.hardwareModel.isSupported == true
#endif
  }
}
extension VZMacOSRestoreImage : ImageInstaller {
  func setupMachine(_ machine: Machine) throws -> MachineConfiguration {
    let temporaryURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: temporaryURL, withIntermediateDirectories: true)
    let configuration = try VZVirtualMachineConfiguration(restoreImage: self, in: temporaryURL)
    try configuration.validate()
    return VirtualMachineConfiguration(vzMachineConfiguration: configuration, currentURL: temporaryURL)
  }
  func beginInstaller(configuration: MachineConfiguration) throws  -> VirtualInstaller  {
    guard let vzConfig = (configuration as? VirtualMachineConfiguration)?.vzMachineConfiguration else {
      throw NSError()
    }
    let machine = VZVirtualMachine(configuration: vzConfig)
    let installer = VZMacOSInstaller(virtualMachine: machine, restoringFromImageAt: self.url)
    let publisher =  VirtualMacOSInstallerPublisher(vzInstaller: installer)
    publisher.begin()
    return publisher
  }
  func headers (withSession session: URLSession = .shared) async throws -> [AnyHashable : Any] {
    
    var request = URLRequest(url: url)
    request.httpMethod = "HEAD"
    let (_, response) = try await session.data(for: request)
    
    guard let response = response as? HTTPURLResponse else {
      throw MissingError.needDefinition(response)
    }
    
    return response.allHeaderFields
  }
  //    var isImageSupported: Bool {
  //        if #available(macOS 13.0, *) {
  //            return self.isSupported
  //        } else {
  //            return self.mostFeaturefulSupportedConfiguration?.hardwareModel.isSupported == true
  //        }
  //    }
}


extension VZMacOSRestoreImage {
  static func fetchLatestSupported () async throws -> VZMacOSRestoreImage {
    try await withCheckedThrowingContinuation({ continuation in
      self.fetchLatestSupported { result in
        continuation.resume(with: result)
      }
    })
  }
  
  static func loadFromURL(_ url: URL) async throws -> VZMacOSRestoreImage {
    try await withCheckedThrowingContinuation({ continuation in
      self.load(from: url, completionHandler: continuation.resume(with:))
    })
  }
}
