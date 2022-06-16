import SwiftUI

extension PreviewProvider {
  static func previewImageFetch (_ closure: @escaping (Result<RestoreImage<PreviewRestoreImageMetadata>,Error>) -> Void) {
      closure(.success(PreviewModel.previewRemoteModel))
  }
}
