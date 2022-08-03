//
// RestoreImageLibraryDocument.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import SwiftUI
import UniformTypeIdentifiers

import BushelMachine

struct RestoreImageLibraryDocument: FileDocument {
  let sourceFileWrapper: FileWrapper?

  var library: RestoreImageLibrary

  init(library: RestoreImageLibrary = .init(), sourceFileWrapper: FileWrapper? = nil) {
    self.library = library
    self.sourceFileWrapper = sourceFileWrapper
  }

  mutating func updateBaseURL(_ url: URL?) {
    guard let url = url else {
      return
    }
    guard let fileWrapper = sourceFileWrapper else {
      return
    }
    guard fileWrapper.isDirectory else {
      return
    }
    guard let childWrappers = fileWrapper.fileWrappers else {
      return
    }
    guard let imageDirectoryWrapper = childWrappers["Restore Images"] else {
      return
    }
    guard let imageWrappers = imageDirectoryWrapper.fileWrappers, imageDirectoryWrapper.isDirectory else {
      return
    }
    let libraryItemSHAsMaps = library.items.map {
      ($0.metadata.url.lastPathComponent, $0.metadata.sha256)
    }
    let libraryItemShas: [String: SHA256] = Dictionary(grouping: libraryItemSHAsMaps) { element in
      element.0
    }.compactMapValues { items in
      guard items.count == 1 else {
        return nil
      }
      return items.first?.1
    }

    let restoreImages = library.items.map { file in
      let fileWrapper = imageWrappers[file.metadata.url.lastPathComponent]
      let fileName = fileWrapper?.filename ?? file.metadata.url.lastPathComponent
      let url = url.appendingPathComponent("Restore Images").appendingPathComponent(fileName)
      let fileWrapperAccessor = fileWrapper.map {
        FileWrapperAccessor(fileWrapper: $0, url: url, sha256: file.metadata.sha256)
      }
      return file.updatingWithURL(url, andFileAccessor: fileWrapperAccessor)
    }

    library = .init(items: restoreImages)
  }

  mutating func beginReload(fromURL url: URL?) async {
    let loader = FileRestoreImageLoader()
    guard let fileWrapper = sourceFileWrapper else {
      return
    }
    guard fileWrapper.isDirectory else {
      return
    }
    guard let childWrappers = fileWrapper.fileWrappers else {
      return
    }
    guard let imageDirectoryWrapper = childWrappers["Restore Images"] else {
      return
    }
    guard let imageWrappers = imageDirectoryWrapper.fileWrappers, imageDirectoryWrapper.isDirectory else {
      return
    }
    let restoreImages = await withTaskGroup(of: RestoreImage?.self) { group in
      for (name, imageWrapper) in imageWrappers {
        let fileName = imageWrapper.filename ?? name
        let accessor = FileWrapperAccessor(fileWrapper: imageWrapper, url: url?.appendingPathComponent("Restore Images").appendingPathComponent(fileName), sha256: nil)
        let imageManagers = AnyImageManagers.all
        group.addTask {
          for manager in imageManagers {
            if let image = try? await manager.load(from: accessor, using: loader) {
              return image
            }
          }
          return nil
        }
      }
      return await group.reduce(into: [RestoreImage?]()) { images, image in
        images.append(image)
      }

    }.compactMap { $0 }.map(RestoreImageLibraryItemFile.init(restoreImage:))
    library = .init(items: restoreImages)
  }

  static let readableContentTypes: [UTType] = [.restoreImageLibrary]

  init(configuration: ReadConfiguration) throws {
    let decoder = JSONDecoder()
    var library: RestoreImageLibrary
    if let data = configuration.file.fileWrappers?["metadata.json"]?.regularFileContents {
      do {
        library = try decoder.decode(RestoreImageLibrary.self, from: data)
      } catch {
        dump(error)
        throw error
      }
    } else {
      library = .init()
    }

    for (index, item) in library.items.enumerated() {
      if let fileWrapper = configuration.file.fileWrappers?["Restore Images"]?.fileWrappers?[item.metadata.url.lastPathComponent] {
        library.items[index].fileAccessor = FileWrapperAccessor(fileWrapper: fileWrapper, url: nil, sha256: nil)
      }
    }
    self.init(library: library, sourceFileWrapper: configuration.file)
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    let fileWrapper: FileWrapper = configuration.existingFile ?? .init(directoryWithFileWrappers: [String: FileWrapper]())

    let existingImageDirectoryFileWrapper = configuration.existingFile?.fileWrappers?["Restore Images"]?.fileWrappers
    let sourceImageDirectoryFileWrapper = sourceFileWrapper?.fileWrappers?["Restore Images"]?.fileWrappers
    let imageFileWrappers = try library.items.compactMap { file -> FileWrapper? in
      if let fileWrapper = existingImageDirectoryFileWrapper?[file.metadata.url.lastPathComponent] {
        return nil
      }
      return try FileWrapper(url: file.metadata.url)
    }

    let encoder = JSONEncoder()
    let data = try encoder.encode(library)
    if imageFileWrappers.count > 0 {
      let imagesDirectoryFileWrapper = configuration.existingFile?.fileWrappers?["Restore Images"] ?? FileWrapper(directoryWithFileWrappers: [:])
      #warning("Crash here Thread 9: '*** Collection <NSConcreteHashTable: 0x6000034c7250> was mutated while being enumerated.'")
      if imagesDirectoryFileWrapper.preferredFilename == nil {
        imagesDirectoryFileWrapper.preferredFilename = "Restore Images"
      }
      _ = imageFileWrappers.map(imagesDirectoryFileWrapper.addFileWrapper)
      fileWrapper.addFileWrapper(imagesDirectoryFileWrapper)
    }

    if let metdataFileWrapper = configuration.existingFile?.fileWrappers?["metadata.json"] {
      let temporaryURL = FileManager.default.createTemporaryFile(for: .json)
      try data.write(to: temporaryURL)
      try metdataFileWrapper.read(from: temporaryURL)
    } else {
      let metdataFileWrapper = FileWrapper(regularFileWithContents: data)
      metdataFileWrapper.preferredFilename = "metadata.json"
      fileWrapper.addFileWrapper(metdataFileWrapper)
    }
    return fileWrapper
  }
}
