//
// RestoreImageDocumentView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
  import BushelMachine
  import SwiftUI
  import UniformTypeIdentifiers

  struct RestoreImageDocumentView<ImageManagerType: ImageManager>: View {
    internal init(
      url _: URL?,
      manager _: ImageManagerType,
      _ fetchImage: @escaping () async throws -> RestoreImage
    ) {
      self.fetchImage = fetchImage
    }

    internal init(
      document: RestoreImageDocument,
      manager: ImageManagerType,
      url: URL? = nil,
      loader: RestoreImageLoader = FileRestoreImageLoader()
    ) {
      let accessor = FileWrapperAccessor(fileWrapper: document.fileWrapper, url: url)
      self.init(url: url, manager: manager) {
        try await loader.load(from: accessor, using: manager)
      }
    }

    let fetchImage: () async throws -> RestoreImage

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
      .task {
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

  #if canImport(Virtualization) && arch(arm64)
    struct RestoreImageDocumentView_Previews: PreviewProvider {
      static var previews: some View {
        RestoreImageDocumentView(url: nil, manager: MockImageManager(metadata: .Previews.venturaBeta3)) {
          .Previews.usingMetadata(.Previews.venturaBeta3)
        }
      }
    }
  #endif
#endif
