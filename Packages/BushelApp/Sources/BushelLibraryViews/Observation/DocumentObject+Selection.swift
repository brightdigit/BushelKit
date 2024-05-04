//
// DocumentObject+Selection.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import Foundation
  import SwiftData
  extension DocumentObject {
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
      object.beginImport(
        .remote(url: url, metadata: selectedHubImage.metadata)
      ) {
        self.restoreImageImportProgress = $0
      } onError: { error in
        Self.logger.error("Unable to import \(url): \(error)")
        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
    }

    func restoreImageFileFrom(result: Result<URL, any Error>) -> LibraryFile? {
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

    func onFileImporterCompleted(_ result: Result<URL, any Error>) {
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
        object.beginImport(
          .local(url: url)
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

    func deleteSelectedItem(withID id: UUID) async {
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

      Self.logger.debug("Deleting Image \(selectedItem)")
      self.queuedRemovalSelectedImageID = nil
      self.selectedItem = nil
      Self.logger.debug("Removing Selected Item")

      assert(selectedItem == id)
      do {
        Self.logger.debug("Deleting \(selectedItem)")
        try await object.deleteImage(withID: selectedItem)
      } catch {
        Self.logger.error("Unable to delete image: \(error)")
        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
      }
    }

    func onSelectionChange() {
      guard let object else {
        Self.logger.error("There is object to select from.")
        assertionFailure("There is object to select from.")
        return
      }

      Task {
        do {
          try await object.save()
        } catch {
          Self.logger.error("Unable to save library: \(error)")
          self.error = assertionFailure(error: error) { error in
            Self.logger.critical("Unknown error: \(error)")
          }
        }
      }
    }
  }
#endif
