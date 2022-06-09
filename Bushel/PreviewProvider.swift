import SwiftUI

extension PreviewProvider {
  static func previewImageFetch (_ closure: @escaping (Result<RemoteImage,Error>) -> Void) {
    closure(.success(.previewModel))
  }
}
