//
// DocumentObject+Initialization.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import Foundation
  import SwiftData
  extension DocumentObject {
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
