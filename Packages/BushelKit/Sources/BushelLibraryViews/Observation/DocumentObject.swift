//
// DocumentObject.swift
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
  class DocumentObject: LoggerCategorized {
    var restoreImageImportProgress: ProgressOperationProperties?
    var object: LibraryObject?
    var error: LibraryError?
    var selectedItem: LibraryImageFile.ID?
    var selectedHubImage: InstallImage?
    var presentFileImporter = false
    var presentFileExporter = false
    var presentHubModal = false
    var presentDeleteImageConfirmation = false
    var queuedRemovalSelectedImageID: LibraryImageFile.ID?

    var queuedRemovalSelectedImage: LibraryImageFile? {
      guard let queuedRemovalSelectedImageID else {
        return nil
      }
      let file = object?.library.items.first(where: {
        $0.id == queuedRemovalSelectedImageID
      })
      assert(file != nil)
      return file
    }

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

    @MainActor
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

    func queueRemovalSelectedItem() {
      guard let selectedItem else {
        Self.logger.error("There is no selected item to queue.")
        assertionFailure("There is no selected item to queue.")
        return
      }

      queuedRemovalSelectedImageID = selectedItem
      self.presentDeleteImageConfirmation = true
    }

    func cancelRemovalSelectedItem(withID id: UUID) {
      guard let selectedItem else {
        Self.logger.error("There is no selected item to remove from queue.")
        assertionFailure("There is no selected item to remove from queue.")
        return
      }

      assert(selectedItem == id)
      self.queuedRemovalSelectedImageID = nil
    }

    func deleteSelectedItem(withID id: UUID) {
      guard let selectedItem else {
        Self.logger.error("There is no selected item to delete.")
        assertionFailure("There is no selected item to delete.")
        return
      }

      guard let object else {
        Self.logger.error("There is object to delete from.")
        assertionFailure("There is object to delete from.")
        return
      }

      assert(selectedItem == id)
      do {
        Self.logger.debug("Deleting \(selectedItem)")
        try object.deleteImage(withID: selectedItem)
      } catch {
        Self.logger.error("Unable to delete image: \(error)")
        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
      self.queuedRemovalSelectedImageID = nil
      self.selectedItem = nil
    }

    @MainActor
    func onSelectionChange() {
      guard let object else {
        Self.logger.error("There is object to select from.")
        assertionFailure("There is object to select from.")
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

    @MainActor
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func onURLChange(from oldValue: URL?, to newValue: URL?) {
      guard oldValue != newValue else {
        Self.logger.debug("New value is the same.")

        return
      }

      guard let newValue else {
        Self.logger.debug("No new value to change to.")
        presentFileExporter = true
        return
      }

      guard object?.matchesURL(newValue) != true else {
        Self.logger.debug("New value is the same url.")
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
