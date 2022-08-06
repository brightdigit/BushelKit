//
// RestoreImageDocumentView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import BushelMachine
import SwiftUI
import UniformTypeIdentifiers

struct MockImageContainer: ImageContainer {
  let metadata: BushelMachine.ImageMetadata

  var fileAccessor: FileAccessor? {
    nil
  }
}

struct MockImageManager: ImageManager {
  func imageContainer(vzRestoreImage _: Void, sha256 _: BushelMachine.SHA256?, fileAccessor _: BushelMachine.FileAccessor?) async throws -> BushelMachine.ImageContainer {
    MockImageContainer(metadata: metadata)
  }

  func restoreImage(from _: BushelMachine.FileAccessor) async throws {
    fatalError()
  }

  func buildMachine(_: BushelMachine.Machine, restoreImage _: Void) -> BushelMachine.VirtualMachineFactory {
    fatalError()
  }

  internal init(metadata: ImageMetadata) {
    self.metadata = metadata
  }

  init() {
    fatalError()
  }

  func session(fromMachine _: BushelMachine.Machine) throws -> BushelMachine.MachineSession {
    fatalError()
  }

  static let systemID: VMSystemID = "mock"

  static let restoreImageContentTypes: [UTType] = []

  func validateAt(_: URL) throws {}

  let metadata: BushelMachine.ImageMetadata
  func loadFromAccessor(_: BushelMachine.FileAccessor) async throws {}

  func imageContainer(vzRestoreImage _: Void, sha256 _: BushelMachine.SHA256?) async throws -> BushelMachine.ImageContainer {
    MockImageContainer(metadata: metadata)
  }

  typealias ImageType = Void
}

struct RestoreImageDocumentView<ImageManagerType: ImageManager>: View {
  let manager: ImageManagerType

  internal init(url: URL?, manager: ImageManagerType, _ fetchImage: @escaping () async throws -> RestoreImage) {
    self.url = url
    self.fetchImage = fetchImage
    self.manager = manager
  }

  internal init(document: RestoreImageDocument, manager: ImageManagerType, url: URL? = nil, loader: RestoreImageLoader = FileRestoreImageLoader()) {
    let accessor = FileWrapperAccessor(fileWrapper: document.fileWrapper, url: url, sha256: nil)
    self.init(url: url, manager: manager) {
      try await loader.load(from: accessor, using: manager)
    }
  }

  //   let document: RestoreImageDocument
  //  let loader : RestoreImageLoader
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
//        RestoreImageDocumentView(document: RestoreImageDocument(loader: MockRestoreImageLoader(restoreImageResult: nil)))
//
//      RestoreImageDocumentView(document: .Previews.previewLoadedDocument)
    // EmptyView()
  }
}
