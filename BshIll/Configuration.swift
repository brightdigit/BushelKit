import Foundation

enum Configuration {
    
    static let scheme = "bshill"
    
  static let baseURLComponents : URLComponents = {
        var components = URLComponents()
        components.scheme = Self.scheme
        return components
    }()
    
}
