//
// DocumentObject+Initialization.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelLibrary
  import Foundation
  import SwiftData
  extension DocumentObject {
    func loadURL(
      _ url: URL?,
      withDatabase database: any Database,
      using librarySystemManager: any LibrarySystemManaging
    ) {
      self.database = database
      self.librarySystemManager = librarySystemManager

      if let url {
        Task {
          do {
            object = try await .init(url, withDatabase: database, using: librarySystemManager)
          } catch let error as BookmarkError where error.details == .fileDoesNotExistAt(url) {
            Self.logger.error("Could not open \(url, privacy: .public): no longer exists")
            presentFileExporter = true
          } catch {
            Self.logger.error("Could not open \(url, privacy: .public): \(error, privacy: .public)")

            self.error = assertionFailure(error: error) { error in
              Self.logger.critical("Unknown error: \(error)")
            }
          }
        }
      } else {
        presentFileExporter = true
      }
    }

    private func setURL(
      to newURL: URL,
      database: any Database,
      manager: any LibrarySystemManaging
    ) async {
      let presentFileExporter: Bool
      do {
        object = try await .init(newURL, withDatabase: database, using: manager)
        presentFileExporter = false
      } catch let error as BookmarkError where error.details == .fileDoesNotExistAt(newURL) {
        Self.logger.error("Could not open \(newURL, privacy: .public): no longer exists")
        presentFileExporter = true
      } catch {
        Self.logger.error("Could not open \(newURL, privacy: .public): \(error)")
        self.error = assertionFailure(error: error) { error in
          Self.logger.critical("Unknown error: \(error)")
        }
        self.presentErrorAlert = true
        return
      }

      Self.logger.debug("Load completed for url at \(newURL.path(), privacy: .public)")
      self.presentFileExporter = presentFileExporter
    }

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

      Self.logger.debug("Loading new url at \(newValue, privacy: .public)")
      guard let database else {
        assertionFailure("Missing model context")
        Self.logger.error("Missing model context")
        return
      }
      guard let librarySystemManager else {
        assertionFailure("Missing model context")
        Self.logger.error("Missing model context")
        return
      }
      Task {
        await setURL(
          to: newValue,
          database: database,
          manager: librarySystemManager
        )
      }
    }
  }
#endif
