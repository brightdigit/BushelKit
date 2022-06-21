import Foundation
import Virtualization

extension VZMacHardwareModel : RestoreImageMetadataHardwareModel {
    
}
extension VZMacOSConfigurationRequirements : RestoreImageMetadataConfiguration {
    typealias RestoreImageMetadataHardwareModelType = VZMacHardwareModel
}

extension VZVirtualMachineConfiguration : MachineConfigurationMetadata {
    
}
extension VZMacOSRestoreImage : RestoreImageMetadata {
    func createMachineConfigurationMetadata(basedOnMachine machine: Machine<VZMacOSRestoreImage>) -> VZVirtualMachineConfiguration {
        fatalError()
    }
    
    typealias MachineConfigurationMetadataType = VZVirtualMachineConfiguration
    
    
    typealias RestoreImageMetadataConfigurationType = VZMacOSConfigurationRequirements
}
extension VZMacOSRestoreImage {
  func localFileNameDownloadedAt(_ date: Date) -> String {
    let pathExtension = self.url.pathExtension
    let lastPathComponent = self.url.deletingPathExtension().lastPathComponent
    let formatter = DateFormatter()
    formatter.dateFormat = "yyMMddHHmmss"
    formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
    return "\(lastPathComponent)[\(formatter.string(from: date))].\(pathExtension)"
  }
  
  static func remoteImageFetch (_ closure: @escaping (Result<RestoreImage<VZMacOSRestoreImage>,Error>) -> Void) {

    self.fetchLatestSupported{ result in
      let vzRestoreImage : VZMacOSRestoreImage
      switch result {
      case .success(let image):
        vzRestoreImage = image
      case .failure(let error):
        closure(.failure(error))
        return
      }
      var request = URLRequest(url: vzRestoreImage.url)
      request.httpMethod = "HEAD"
      URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error {
          closure(.failure(error))
          return
        }
        
        guard let response = response as? HTTPURLResponse else {
          closure(.failure(NSError()))
          return
        }

        let remoteImage : RestoreImage
        do {
          remoteImage = try .init(vzRestoreImage: vzRestoreImage, headers: response.allHeaderFields)
        } catch {
          closure(.failure(error))
          return
        }
        
        closure(.success(remoteImage))
      }.resume()
    }
  }
}
