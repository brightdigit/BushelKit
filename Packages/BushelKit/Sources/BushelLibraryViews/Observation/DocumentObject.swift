//
// DocumentObject.swift
// Copyright (c) 2023 BrightDigit.
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

  @Observable
  class DocumentObject: Loggable {
    var restoreImageImportProgress: ProgressOperationProperties?
    var object: LibraryObject? {
      didSet {
        self.bindableImage = self.object?.libraryImageObject(withID: self.selectedItem)
      }
    }

    var error: LibraryError?
    var selectedItem: LibraryImageFile.ID? {
      didSet {
        self.bindableImage = self.object?.libraryImageObject(withID: self.selectedItem)
        Self.logger.debug("Updating BindableImage to \(self.selectedItem?.uuidString ?? "nil")")
      }
    }

    var selectedHubImage: InstallImage?
    var presentFileImporter = false
    var presentFileExporter = false
    var presentHubModal = false
    var presentDeleteImageConfirmation = false
    var queuedRemovalSelectedImageID: LibraryImageFile.ID?

    var bindableImage: LibraryImageObject?

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
  }
#endif
