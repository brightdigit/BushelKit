//
// FileWrapper.swift
// Copyright (c) 2022 BrightDigit.
//

#if !os(Linux)
  import BushelMachine
  import Foundation

  extension FileWrapper {
    static func fromResourceImageLibraryFile(
      _ file: RestoreImageLibraryItemFile,
      directoryChildren: [String: FileWrapper]?,
      sourceURL: URL?
    ) throws -> FileWrapper? {
      if let fileWrapper = directoryChildren?[file.fileName] {
        return fileWrapper
      } else if let sourceFileURL = try? file.fileAccessor?.getURL() {
        if let expectedDestinationURL = sourceURL?
          .appendingPathComponent("Restore Images")
          .appendingPathComponent(file.fileName) {
          if FileManager.default.fileExists(atPath: expectedDestinationURL.path) {
            return nil
          }
        }
        return try FileWrapper(url: sourceFileURL)
      } else {
        return nil
      }
    }

    func addMetadata(
      forRestoreLibrary snapshot: RestoreImageLibrary,
      fromExistingFile existingFile: FileWrapper?
    ) throws {
      let data = try Configuration.JSON.encoder.encode(snapshot)
      if let metdataFileWrapper = existingFile?.fileWrappers?["metadata.json"] {
        let temporaryURL = FileManager.default.createTemporaryFile(for: .json)
        try data.write(to: temporaryURL)
        try metdataFileWrapper.read(from: temporaryURL)
      } else {
        let metdataFileWrapper = FileWrapper(regularFileWithContents: data)
        metdataFileWrapper.preferredFilename = "metadata.json"
        addFileWrapper(metdataFileWrapper)
      }
    }

    func addImages(_ imageFileWrappers: [FileWrapper], fromExistingFile existingFile: FileWrapper?) {
      if !imageFileWrappers.isEmpty {
        let imagesDirectoryFileWrapper =
          existingFile?.fileWrappers?["Restore Images"] ??
          FileWrapper(directoryWithFileWrappers: [:])
        if imagesDirectoryFileWrapper.preferredFilename == nil {
          imagesDirectoryFileWrapper.preferredFilename = "Restore Images"
        }
        _ = imageFileWrappers.map(imagesDirectoryFileWrapper.addFileWrapper)
        addFileWrapper(imagesDirectoryFileWrapper)
      }
    }

    var imageWrappers: [String: FileWrapper]? {
      guard isDirectory else {
        return nil
      }
      guard let childWrappers = fileWrappers else {
        return nil
      }
      guard let imageDirectoryWrapper = childWrappers["Restore Images"] else {
        return nil
      }
      guard let imageWrappers = imageDirectoryWrapper.fileWrappers, imageDirectoryWrapper.isDirectory else {
        return nil
      }
      return imageWrappers
    }

    // swiftlint:disable:next function_body_length
    func loadRestoreImageFiles(
      fromDirectoryURL directoryURL: URL?,
      using loader: RestoreImageLoader
    ) async -> [RestoreImageLibraryItemFile] {
      guard let imageWrappers = imageWrappers else {
        return []
      }
      let restoreImages = await withTaskGroup(of: RestoreImage?.self) { group -> [RestoreImage?] in
        for (name, imageWrapper) in imageWrappers {
          let imageWrapperAccessor = FileWrapperAccessor(
            fileWrapper: imageWrapper,
            directoryURL: directoryURL,
            name: name
          )
          group.addTask {
            await AnyImageManagers.restoreImageFrom(
              accessor: imageWrapperAccessor,
              using: loader
            )
          }
        }
        return await group.reduce(into: [RestoreImage?]()) { images, image in
          images.append(image)
        }
      }.compactMap { $0 }.compactMap(RestoreImageLibraryItemFile.init(loadFromImage:))
      return restoreImages
    }
  }
#endif
