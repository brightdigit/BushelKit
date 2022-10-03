//
// RestoreImageLibraryDocument.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI
  import UniformTypeIdentifiers

  class RestoreImageLibraryDocument: BushelDocument, BlankFileDocument {
    let sourceFileWrapper: FileWrapper?
    var sourceURL: URL?
    @Published var library: RestoreImageLibrary
    @Published var trashedRestoreImages = Set<UUID>()

    func trashRestoreImage(withID id: UUID) {
      DispatchQueue.main.async {
        self.trashedRestoreImages.formUnion([id])
      }
    }

    func putBackRestoreImage(withID id: UUID) {
      DispatchQueue.main.async {
        self.trashedRestoreImages.remove(id)
      }
    }

    var filteredItems: [RestoreImageLibraryItemFile] {
      library.items.filter {
        !trashedRestoreImages.contains($0.id)
      }
    }

    static let allowedContentTypes: [UTType] = [.restoreImageLibrary]
    func snapshot(contentType _: UTType) throws -> RestoreImageLibrary {
      library
    }

    static func saveBlankDocumentAt(_ url: URL) throws {
      let library = RestoreImageLibrary()
      let data = try Configuration.JSON.encoder.encode(library)
      let restoreLibrariesDir = url.appendingPathComponent("Restore Images")
      let metadataFileURL = url.appendingPathComponent("metadata.json")
      try FileManager.default.createDirectory(at: restoreLibrariesDir, withIntermediateDirectories: true)
      FileManager.default.createFile(atPath: metadataFileURL.path, contents: data)
    }

    func fileWrapper(
      snapshot: RestoreImageLibrary,
      configuration: WriteConfiguration
    ) throws -> FileWrapper {
      let fileWrapper: FileWrapper =
        configuration.existingFile ??
        .init(directoryWithFileWrappers: [String: FileWrapper]())

      let existingImageDirectoryFileWrapper = configuration.existingFile?
        .fileWrappers?["Restore Images"]?
        .fileWrappers

      let imageFileWrappers = try snapshot.items
        .compactMap { file -> FileWrapper? in
          try FileWrapper.fromResourceImageLibraryFile(
            file,
            directoryChildren: existingImageDirectoryFileWrapper,
            sourceURL: self.sourceURL
          )
        }
      fileWrapper.addImages(imageFileWrappers, fromExistingFile: configuration.existingFile)

      try fileWrapper.addMetadata(forRestoreLibrary: snapshot, fromExistingFile: configuration.existingFile)

      return fileWrapper
    }

    typealias Snapshot = RestoreImageLibrary

    static let readableContentTypes: [UTType] = [.restoreImageLibrary]

    init(library: RestoreImageLibrary = .init(), sourceFileWrapper: FileWrapper? = nil) {
      self.library = library
      self.sourceFileWrapper = sourceFileWrapper
    }

    static func restoreImageLibrary(fromFileWrapper rootFileWrapper: FileWrapper) throws -> RestoreImageLibrary {
      if let data = rootFileWrapper.fileWrappers?["metadata.json"]?.regularFileContents {
        do {
          return try Configuration.JSON.tryDecoding(data)
        } catch {
          throw error
        }
      } else {
        return .init()
      }
    }

    required convenience init(configuration: ReadConfiguration) throws {
      Self.logger.log("opening file at \(configuration.file.description)")

      var library: RestoreImageLibrary = try Self.restoreImageLibrary(fromFileWrapper: configuration.file)

      for (index, item) in library.items.enumerated() {
        if let fileWrapper = configuration.file
          .fileWrappers?["Restore Images"]?
          .fileWrappers?[item.id.uuidString] {
          library.items[index].fileAccessor = FileWrapperAccessor(fileWrapper: fileWrapper, url: nil)
        }
      }
      self.init(library: library, sourceFileWrapper: configuration.file)
    }

    func importFile(_ file: RestoreImageLibraryItemFile) {
      Self.logger.log("importing file \(file.fileName)")
      let sourceFileURL: URL
      guard let sourceURL = sourceURL else {
        Self.logger.error("can't importing file \(file.fileName); no sourceURL")
        return
      }
      do {
        sourceFileURL = try file.getURL()
      } catch {
        Self.logger.error("can't importing file \(file.fileName); failure to get url from file: \(error.localizedDescription)")
        return
      }
      do {
        try FileManager.default.copyRestoreImage(at: sourceFileURL, toLibraryAt: sourceURL, withName: file.fileName)
      } catch {
        Self.logger.error("can't importing file \(file.fileName); failure to get copy file: \(error.localizedDescription)")
        return
      }

      library.items.append(file)
    }

    func updateBaseURL(_ url: URL) {
      sourceURL = url

      guard let imageWrappers = sourceFileWrapper?.imageWrappers else {
        return
      }

      let restoreImages = library.items.map { file -> RestoreImageLibraryItemFile in
        let fileWrapper = imageWrappers[file.fileName]
        let fileName = fileWrapper?.filename ?? file.fileName
        let url = url.appendingPathComponent("Restore Images").appendingPathComponent(fileName)
        let fileWrapperAccessor = fileWrapper.map {
          FileWrapperAccessor(fileWrapper: $0, url: url)
        }
        return file.updatingWithURL(url, andFileAccessor: fileWrapperAccessor)
      }

      library = .init(items: restoreImages)
    }

    func beginReload(fromURL url: URL?) async {
      let loader = FileRestoreImageLoader()

      guard let sourceFileWrapper = sourceFileWrapper else {
        return
      }
      let restoreImageDirectoryURL = url?.appendingPathComponent("Restore Images")
      let restoreImages = await sourceFileWrapper.loadRestoreImageFiles(fromDirectoryURL: restoreImageDirectoryURL, using: loader)
      library = .init(items: restoreImages)
    }
  }

  extension ObservedObject: RestoreLibraryItemsListable where ObjectType == RestoreImageLibraryDocument {
    var listItems: [RestoreImageLibraryItemFile] {
      wrappedValue.filteredItems
    }

    func bindingFor(_ file: RestoreImageLibraryItemFile) -> Binding<RestoreImageLibraryItemFile> {
      projectedValue.library.bindingFor(file)
    }
  }
#endif
