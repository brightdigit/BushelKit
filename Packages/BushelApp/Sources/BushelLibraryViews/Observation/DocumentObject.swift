//
// DocumentObject.swift
// Copyright (c) 2024 BrightDigit.
//

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

  @MainActor
  @Observable
  internal final class DocumentObject: Loggable {
    internal var restoreImageImportProgress: ProgressOperationProperties?
    internal var object: LibraryObject? {
      didSet {
        Task { @MainActor in
          self.bindableImage = await self.object?.libraryImageObject(withID: self.selectedItem)
        }
      }
    }

    internal var error: LibraryError?
    internal var selectedItem: LibraryImageFile.ID? {
      didSet {
        Task { @MainActor in
          self.bindableImage = await self.object?.libraryImageObject(withID: self.selectedItem)
          Self.logger.debug("Updating BindableImage to \(self.selectedItem?.uuidString ?? "nil")")
        }
      }
    }

    internal var selectedHubImage: (any InstallImage)?
    internal var presentFileImporter = false
    internal var presentFileExporter = false
    internal var presentHubModal = false
    internal var presentDeleteImageConfirmation = false
    internal var queuedRemovalSelectedImageID: LibraryImageFile.ID?

    internal var bindableImage: LibraryImageObject?

    internal var queuedRemovalSelectedImage: LibraryImageFile? {
      guard let queuedRemovalSelectedImageID else {
        return nil
      }
      let file = object?.library.items.first(where: {
        $0.id == queuedRemovalSelectedImageID
      })
      assert(file != nil)
      return file
    }

    internal var presentErrorAlert: Bool {
      get {
        self.error != nil
      }
      set {
        self.error = newValue ? self.error : nil
      }
    }

    @ObservationIgnored
    internal var database: (any Database)?

    @ObservationIgnored
    internal var librarySystemManager: (any LibrarySystemManaging)?

    internal init(
      restoreImageImportProgress: ProgressOperationProperties? = nil,
      error: LibraryError? = nil,
      selectedItem: LibraryImageFile.ID? = nil,
      presentFileImporter: Bool = false,
      database: (any Database)? = nil,
      librarySystemManager: (any LibrarySystemManaging)? = nil
    ) {
      self._error = error
      self._selectedItem = selectedItem
      self._presentFileImporter = presentFileImporter
      self.database = database
      self.librarySystemManager = librarySystemManager
      self.restoreImageImportProgress = restoreImageImportProgress
    }
  }
#endif
