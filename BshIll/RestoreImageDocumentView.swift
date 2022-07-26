//
//  RestoreImageView.swift
//  BshIll
//
//  Created by Leo Dion on 6/22/22.
//

import SwiftUI



struct RestoreImageDocumentView: View {
  internal init(url: URL?, _ fetchImage : @escaping () async throws -> RestoreImage) {
    self.url = url
    self.fetchImage = fetchImage
  }
  internal init(document: RestoreImageDocument, url: URL? = nil, loader: RestoreImageLoader = FileRestoreImageLoader()) {
    let accessor = FileWrapperAccessor(fileWrapper: document.fileWrapper, url: url, sha256: nil)
    self.init(url: url) {
      try await loader.load(from: accessor)
    }
  }
  
//   let document: RestoreImageDocument
//  let loader : RestoreImageLoader
  let fetchImage : () async throws -> RestoreImage
  let url : URL?
  @State var restoreImageResult : Result<RestoreImage, Error>?
  
  var body: some View {
    Group{
      switch self.restoreImageResult {
      case .none:
        ProgressView()
      case .success(let image):
        RestoreImageView(image: image).fixedSize()
      default:
        EmptyView()
      }
    }
    .onAppear{
      Task {
        let restoreImageResult : Result<RestoreImage, Error>
        do {
          let image = try await self.fetchImage()
          restoreImageResult = .success(image)
        } catch {
          restoreImageResult = .failure(error)
        }
        DispatchQueue.main.async {
          self.restoreImageResult = restoreImageResult
        }
      }
       
    }
    }
}

struct RestoreImageDocumentView_Previews: PreviewProvider {
    static var previews: some View {
      RestoreImageDocumentView(url: nil) {
        return .Previews.usingMetadata(.Previews.venturaBeta3)
      }
//        RestoreImageDocumentView(document: RestoreImageDocument(loader: MockRestoreImageLoader(restoreImageResult: nil)))
//
//      RestoreImageDocumentView(document: .Previews.previewLoadedDocument)
      //EmptyView()
    }
}


