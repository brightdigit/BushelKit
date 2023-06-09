//
// Windows.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(AppKit) && canImport(UniformTypeIdentifiers)
  import AppKit
  import BushelMachine
  import FelinePine
  import SwiftUI
  import UniformTypeIdentifiers

  enum Windows: LoggerCategorized {
    static let loggingCategory = LoggerCategory.ui
    static func showNewSavedDocumentWindow<BlankDocumentType: BlankFileDocument>(
      ofType type: BlankDocumentType.Type
    ) {
      let panel = NSSavePanel()
      panel.allowedContentTypes = type.allowedContentTypes
      panel.isExtensionHidden = true
      panel.begin { response in
        guard let fileURL = panel.url, response == .OK else {
          return
        }
        do {
          try type.saveBlankDocumentAt(fileURL)
        } catch {
          Self.logger.error("unable to save blank doc at \(fileURL.path): \(error.localizedDescription)")
          return
        }
        self.openDocumentAtURL(fileURL)
      }
      ApplicationContext.shared.refreshRecentDocuments()
    }

//
//    static func showNewDocumentWindow(ofType type: UTType) {
//      let documentController = NSDocumentController.shared
//      let newDocument: NSDocument
//      do {
//        newDocument = try documentController.makeUntitledDocument(ofType: type.identifier)
//      } catch {
//        Self.logger.error(
//          "unable to make untitled document of type \(type.description): \(error.localizedDescription)"
//        )
//        return
//      }
//
//      documentController.addDocument(newDocument)
//      newDocument.makeWindowControllers()
//      newDocument.showWindows()
//
//      ApplicationContext.shared.refreshRecentDocuments()
//    }

    static func openDocumentAtURL(_ url: URL, andDisplay display: Bool = true) {
      let documentController = NSDocumentController.shared

      documentController.openDocument(
        withContentsOf: url,
        display: display
      ) { document, alreadyDisplayed, error in
        if let document = document {
          guard !alreadyDisplayed else {
            return
          }

          documentController.addDocument(document)
          document.makeWindowControllers()
        } else if let error = error {
          Self.logger.error("unable to open doc at \(url.path): \(error)")
        } else {
          Self.logger.error("unable to open doc at \(url.path)")
        }
      }
      ApplicationContext.shared.refreshRecentDocuments()
    }

    static func openWindow<HandleType: WindowOpenHandle>(withHandle handle: HandleType) {
      NSWorkspace.shared.open(URL(forHandle: handle))
    }
  }
#endif
