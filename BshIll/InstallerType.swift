import Foundation
import Virtualization

enum InstallerType : String, Codable {
  case vzMacOS
}

extension InstallerType {
  func validateAt (_ url: URL) -> Bool {
    return true
  }
}
