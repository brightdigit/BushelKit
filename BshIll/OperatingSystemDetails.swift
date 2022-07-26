import Foundation
import Virtualization

struct OperatingSystemDetails : Codable {
  enum System : String, Codable {
    case macOS
  }
  let type : System
  let version: OperatingSystemVersion
  let buildVersion : String
}
