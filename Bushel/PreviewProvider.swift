import SwiftUI

extension PreviewProvider {
  static func previewImageFetch (_ closure: @escaping (Result<RestoreImage,Error>) -> Void) {
    closure(.success(.previewModel))
  }
}
