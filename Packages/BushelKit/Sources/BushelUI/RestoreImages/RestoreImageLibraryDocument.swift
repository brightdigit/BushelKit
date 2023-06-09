//
// RestoreImageLibraryDocument.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelVirtualization
  import SwiftUI
  import UniformTypeIdentifiers

  class RestoreImageLibraryDocument: BushelDocument, BlankFileDocument {
    // typealias Snapshot = RestoreImageLibrary

    static let readableContentTypes: [UTType] = [.restoreImageLibrary]
    static let allowedContentTypes: [UTType] = [.restoreImageLibrary]
    let sourceFileWrapper: FileWrapper?
    var sourceURL: URL?
    @Published var library: RestoreImageLibrary
    @Published var trashedRestoreImages = Set<UUID>()

    var filteredItems: [RestoreImageLibraryItemFile] {
      library.items.filter {
        !trashedRestoreImages.contains($0.id)
      }
    }

    init(library: RestoreImageLibrary = .init(), sourceFileWrapper: FileWrapper? = nil) {
      self.library = library
      self.sourceFileWrapper = sourceFileWrapper
    }

    required convenience init(configuration: ReadConfiguration) throws {
      Self.logger.log("opening file at \(configuration.file.description)")

      var library: RestoreImageLibrary = try Self.restoreImageLibrary(fromFileWrapper: configuration.file)

      for (index, item) in library.items.enumerated() {
        if let fileWrapper = configuration.file
          .fileWrappers?[Paths.restoreImagesDirectoryName]?
          .fileWrappers?[item.id.uuidString] {
          library.items[index].fileAccessor = FileWrapperAccessor(fileWrapper: fileWrapper, url: nil)
        }
      }
      self.init(library: library, sourceFileWrapper: configuration.file)
      ApplicationContext.shared.refreshRecentDocuments()
    }

    static func restoreImageLibrary(
      fromFileWrapper rootFileWrapper: FileWrapper
    ) throws -> RestoreImageLibrary {
      if let data = rootFileWrapper.fileWrappers?[Paths.restoreLibraryJSONFileName]?.regularFileContents {
        do {
          return try Configuration.JSON.tryDecoding(data)
        } catch {
          throw error
        }
      } else {
        return .init()
      }
    }

    static func saveBlankDocumentAt(_ url: URL) throws {
      let library = RestoreImageLibrary()
      let data = try Configuration.JSON.encoder.encode(library)
      let restoreLibrariesDir = url.appendingPathComponent(Paths.restoreImagesDirectoryName)
      let metadataFileURL = url.appendingPathComponent(Paths.restoreLibraryJSONFileName)
      try FileManager.default.createDirectory(at: restoreLibrariesDir, withIntermediateDirectories: true)
      FileManager.default.createFile(atPath: metadataFileURL.path, contents: data)
    }

    func trashRestoreImage(withID id: UUID) {
      #warning("Swap for MainActor")
      DispatchQueue.main.async {
        self.trashedRestoreImages.formUnion([id])
      }
    }

    func putBackRestoreImage(withID id: UUID) {
      #warning("Swap for MainActor")
      DispatchQueue.main.async {
        self.trashedRestoreImages.remove(id)
      }
    }

    func snapshot(contentType _: UTType) throws -> RestoreImageLibrary {
      library
    }

    func fileWrapper(
      snapshot: RestoreImageLibrary,
      configuration: WriteConfiguration
    ) throws -> FileWrapper {
      let fileWrapper: FileWrapper =
        configuration.existingFile ??
        .init(directoryWithFileWrappers: [String: FileWrapper]())

      let existingImageDirectoryFileWrapper = configuration.existingFile?
        .fileWrappers?[Paths.restoreImagesDirectoryName]?
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

    // swiftlint:disable:next function_body_length
    func importFile(_ file: RestoreImageLibraryItemFile) async {
      Self.logger.log("importing file \(file.fileName)")
      let sourceFileURL: URL

      guard let sourceURL = sourceURL else {
        Self.logger.error("can't importing file \(file.fileName); no sourceURL")
        return
      }
      do {
        sourceFileURL = try file.getURL()
      } catch {
        // swiftlint:disable:next line_length
        Self.logger.error("can't importing file \(file.fileName); failure to get url from file: \(error.localizedDescription)")
        return
      }

      let newURL: URL
      do {
        newURL = try await withCheckedThrowingContinuation { continuation in
          continuation.resume(with:
            Result { try FileManager.default.copyRestoreImage(
              at: sourceFileURL,
              toLibraryAt: sourceURL,
              withName: file.fileName
            )
            }
          )
        }
      } catch {
        // swiftlint:disable:next line_length
        Self.logger.error("can't importing file \(file.fileName); failure to get copy file: \(error.localizedDescription)")
        return
      }

      await MainActor.run {
        library.items.append(
          file.updatingWithURL(newURL, andFileAccessor: nil)
        )
      }
    }

    func updateBaseURL(_ url: URL) {
      sourceURL = url

      guard let imageWrappers = sourceFileWrapper?.imageWrappers else {
        return
      }

      let restoreImages = library.items.map { file -> RestoreImageLibraryItemFile in
        let fileWrapper = imageWrappers[file.fileName]
        let fileName = fileWrapper?.filename ?? file.fileName
        let url = url
          .appendingPathComponent(Paths.restoreImagesDirectoryName)
          .appendingPathComponent(fileName)
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
      let restoreImageDirectoryURL = url?.appendingPathComponent(Paths.restoreImagesDirectoryName)
      let restoreImages = await sourceFileWrapper.loadRestoreImageFiles(
        fromDirectoryURL: restoreImageDirectoryURL,
        using: loader
      )
      #warning("Swap for MainActor")
      DispatchQueue.main.async {
        self.library = .init(items: restoreImages)
      }
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
