//
// RestoreImageDocumentView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/10/22.
//

import BushelMachine
import SwiftUI
import UniformTypeIdentifiers

struct RestoreImageDocumentView<ImageManagerType: ImageManager>: View {
  let manager: ImageManagerType

  internal init(url: URL?, manager: ImageManagerType, _ fetchImage: @escaping () async throws -> RestoreImage) {
    self.url = url
    self.fetchImage = fetchImage
    self.manager = manager
  }

  internal init(document: RestoreImageDocument, manager: ImageManagerType, url: URL? = nil, loader: RestoreImageLoader = FileRestoreImageLoader()) {
    let accessor = FileWrapperAccessor(fileWrapper: document.fileWrapper, url: url)
    self.init(url: url, manager: manager) {
      try await loader.load(from: accessor, using: manager)
    }
  }
  
  let fetchImage: () async throws -> RestoreImage
  let url: URL?
  @State var restoreImageResult: Result<RestoreImage, Error>?

  var body: some View {
    Group {
      switch self.restoreImageResult {
      case .none:
        ProgressView()
      case let .success(image):
        RestoreImageView(image: image).fixedSize()
      default:
        EmptyView()
      }
    }
    .onAppear {
      Task {
        let restoreImageResult: Result<RestoreImage, Error>
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
    RestoreImageDocumentView(url: nil, manager: MockImageManager(metadata: .Previews.venturaBeta3)) {
      .Previews.usingMetadata(.Previews.venturaBeta3)
    }
  }
}
