//
// RestoreImageDocumentView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/10/22.
//

import BushelMachine
import SwiftUI
import UniformTypeIdentifiers

struct MockImageManager: ImageManager {
  func defaultName(for _: BushelMachine.ImageMetadata) -> String {
    "Windows Vista"
  }

  func containerFor(image _: Void, fileAccessor: BushelMachine.FileAccessor?) async throws -> BushelMachine.ImageContainer {
    MockImageContainer(location: fileAccessor.map(ImageLocation.file) ?? .remote(.init(forHandle: BasicWindowOpenHandle.machine)), metadata: metadata)
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

  func imageContainer(vzRestoreImage _: Void) async throws -> BushelMachine.ImageContainer {
    MockImageContainer(location: .file(URLAccessor(url: URL(string: "file:///var/folders/5d/8rl1m9ts5r96dxdh4rp_zx100000gn/T/com.brightdigit.BshIll/B6844821-A5C8-42B5-80C2-20F815FB920E.ipsw")!)), metadata: metadata)
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
    let accessor = FileWrapperAccessor(fileWrapper: document.fileWrapper, url: url)
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
