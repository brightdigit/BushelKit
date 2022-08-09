//
// Windows.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/9/22.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

protocol BlankFileDocument {
  static var allowedContentTypes: [UTType] { get }
  static func saveBlankDocumentAt(_ url: URL) throws
}

public enum Windows {
  static func showNewSavedDocumentWindow<BlankDocumentType: BlankFileDocument>(ofType type: BlankDocumentType.Type) {
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
        dump(error)
        return
      }
      self.openDocumentAtURL(fileURL)
    }
  }

  static func showNewDocumentWindow(ofType type: UTType) {
    let dc = NSDocumentController.shared
    if let newDocument = try? dc.makeUntitledDocument(ofType: type.identifier) {
      dc.addDocument(newDocument)
      newDocument.makeWindowControllers()
      newDocument.showWindows()
    }
  }

  static func openDocumentAtURL(_ url: URL, andDisplay display: Bool = true) {
    let dc = NSDocumentController.shared

    dc.openDocument(withContentsOf: url, display: display) { document, alreadyDisplayed, error in
      if let document = document {
        guard !alreadyDisplayed else {
          return
        }
        dc.addDocument(document)
        document.makeWindowControllers()
        document.showWindows()
      } else {
        dump(error)
      }
    }
  }

  static func openWindow(withHandle handle: WindowOpenHandle) {
    NSWorkspace.shared.open(URL(forHandle: handle))
  }
}
