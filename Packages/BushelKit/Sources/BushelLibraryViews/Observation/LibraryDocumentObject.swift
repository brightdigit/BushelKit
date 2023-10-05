//
// LibraryDocumentObject.swift
// Copyright (c) 2023 BrightDigit.
//

// swiftlint:disable file_length

#warning("split file up")

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelLibrary
  import BushelLibraryData
  import BushelLogging
  import BushelProgressUI
  import BushelViewsCore
  import Foundation
  import Observation
  import SwiftData
  import SwiftUI

  @Observable
  class LibraryDocumentObject: LoggerCategorized {
    var restoreImageImportProgress: ProgressOperationProperties?
    var object: LibraryObject?
    var error: LibraryError?
    var selectedItem: LibraryImageFile.ID?
    var selectedHubImage: InstallImage?
    var presentFileImporter = false
    var presentFileExporter = false
    var presentHubModal = false
    var presentErrorAlert: Bool {
      get {
        self.error != nil
      }
      set {
        self.error = newValue ? self.error : nil
      }
    }

    @ObservationIgnored
    var modelContext: ModelContext?

    @ObservationIgnored
    var librarySystemManager: (any LibrarySystemManaging)?

    internal init(
      restoreImageImportProgress: ProgressOperationProperties? = nil,
      error: LibraryError? = nil,
      selectedItem: LibraryImageFile.ID? = nil,
      presentFileImporter: Bool = false,
      modelContext: ModelContext? = nil,
      librarySystemManager: (any LibrarySystemManaging)? = nil
    ) {
      self._error = error
      self._selectedItem = selectedItem
      self._presentFileImporter = presentFileImporter
      self.modelContext = modelContext
      self.librarySystemManager = librarySystemManager
      self.restoreImageImportProgress = restoreImageImportProgress
    }

    func onHubImageSelected() {
      guard let selectedHubImage else {
        return
      }
      let url = selectedHubImage.url
      guard let object else {
        Self.logger.error("Error missing library file.")
        let error = LibraryError.missingInitializedProperty(.bookmarkData)
        assertionFailure(error: error)
        self.error = error
        return
      }
      object.startImportRemoteImageAt(
        url,
        metadata: selectedHubImage.metadata
      ) {
        self.restoreImageImportProgress = $0
      } onError: { error in
        Self.logger.error("Unable to import \(url): \(error)")
        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
    }

    func restoreImageFileFrom(result: Result<URL, Error>) -> LibraryFile? {
      let newResult: Result<URL, LibraryError>
      do {
        newResult = try assertionFailure(result: result)
      } catch {
        Self.logger.critical("Unknown Error: \(error)")
        return nil
      }
      switch newResult {
      case let .failure(error):
        Self.logger.error("Error importing restore image: \(error)")

        assertionFailure(error: error)
        self.error = error
        return nil

      case let .success(url):
        Self.logger.debug("Importing Restore Image Selected: \(url)")
        return .init(url: url)
      }
    }

    func onFileImporterCompleted(_ result: Result<URL, Error>) {
      let newResult: Result<URL, LibraryError>
      do {
        newResult = try assertionFailure(result: result)
      } catch {
        Self.logger.critical("Unknown Error: \(error)")
        return
      }
      switch (newResult, object) {
      case let (.failure(error), _):
        Self.logger.error("Error importing restore image: \(error)")

        assertionFailure(error: error)
        self.error = error

      case (_, .none):
        assertionFailure()
        Self.logger.error("Error missing library file.")
        let error = LibraryError.missingInitializedProperty(.bookmarkData)
        assertionFailure(error: error)
        self.error = error

      case let (.success(url), .some(object)):
        Self.logger.debug("Importing Restore Image Selected: \(url)")
        object.startImportRestoreImageAt(
          url
        ) {
          self.restoreImageImportProgress = $0
        } onError: { error in
          Self.logger.error("Unable to import \(url): \(error)")
          self.error = assertionFailure(error: error) { error in
            Self.logger.critical("Unknown error: \(error)")
          }
        }
      }
    }

    func loadURL(
      _ url: URL?,
      withContext modelContext: ModelContext,
      using librarySystemManager: any LibrarySystemManaging
    ) {
      self.modelContext = modelContext
      self.librarySystemManager = librarySystemManager

      if let url {
        do {
          object = try .init(url, withContext: modelContext, using: librarySystemManager)
        } catch let error as BookmarkError where error.details == .fileDoesNotExistAt(url) {
          Self.logger.error("Could not open \(url, privacy: .public): no longer exists")
          presentFileExporter = true
        } catch {
          Self.logger.error("Could not open \(url, privacy: .public): \(error, privacy: .public)")

          self.error = assertionFailure(error: error) { error in
            Self.logger.critical("Unknown error: \(error)")
          }
        }
      } else {
        presentFileExporter = true
      }
    }

    func onSelectionChange() {
      guard let object else {
        return
      }

      do {
        try object.save()
      } catch {
        Self.logger.error("Unable to save library: \(error)")
        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
    }

    // swiftlint:disable:next cyclomatic_complexity
    func onURLChange(from oldValue: URL?, to newValue: URL?) {
      guard oldValue != newValue else {
        return
      }

      guard let newValue else {
        presentFileExporter = true
        return
      }

      guard object?.matchesURL(newValue) != true else {
        return
      }

      defer {
        self.presentFileExporter = false
      }

      Self.logger.debug("Loading new url at \(newValue, privacy: .public)")
      guard let modelContext else {
        assertionFailure("Missing model context")
        Self.logger.error("Missing model context")
        return
      }
      guard let librarySystemManager else {
        assertionFailure("Missing model context")
        Self.logger.error("Missing model context")
        return
      }
      do {
        object = try .init(newValue, withContext: modelContext, using: librarySystemManager)
      } catch let error as BookmarkError where error.details == .fileDoesNotExistAt(newValue) {
        Self.logger.error("Could not open \(newValue, privacy: .public): no longer exists")
        presentFileExporter = true
      } catch {
        Self.logger.error("Could not open \(newValue, privacy: .public): \(error)")
        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
        self.presentErrorAlert = true
        return
      }

      Self.logger.debug("Load completed for url at \(newValue.path(), privacy: .public)")
    }
  }
#endif