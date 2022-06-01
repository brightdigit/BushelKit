import SwiftUI

extension PreviewProvider {
  static func previewImageFetch (_ closure: @escaping (Result<RemoteImage,Error>) -> Void) {
    closure(.success(.init(buildVersion: "21F79", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0), url: .init(string: "https://apple.com")!, contentLength: 13837340777, lastModified: .init(), sha256: .init(hexidecialString: "1f9e921f77bbcb5cf78026389d6f7331cdd675bc081ffac77fc00405a7e822b3")!)))
  }
}
