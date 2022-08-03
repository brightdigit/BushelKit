//
// Windows.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

public enum Windows {
  static func showNewDocumentWindow(ofType type: UTType) {
    let dc = NSDocumentController.shared
    if let newDocument = try? dc.makeUntitledDocument(ofType: type.identifier) {
      dc.addDocument(newDocument)
      newDocument.makeWindowControllers()
      newDocument.showWindows()
    }
  }

  static func showNewDocumentWindow<FileDocumentType: CreatableFileDocument>(ofType type: FileDocumentType.Type) throws -> FileDocumentType {
    let dc = NSDocumentController.shared
    let newDocument = try dc.makeUntitledDocument(ofType: type.untitledDocumentType.identifier)
    guard let fileDocument = newDocument as? FileDocumentType else {
      dump(newDocument)
      throw DocumentError.undefinedType("Unable to create document as type.", (newDocument, type))
    }
    dc.addDocument(newDocument)
    newDocument.makeWindowControllers()
    newDocument.showWindows()
    return fileDocument
  }

  static func openDocumentAtURL(_ url: URL, andDisplay display: Bool = true) {
    let dc = NSDocumentController.shared
    dc.openDocument(withContentsOf: url, display: display) { document, alreadyDisplayed, _ in
      if let document = document {
        guard !alreadyDisplayed else {
          return
        }
        dc.addDocument(document)
        document.makeWindowControllers()
        document.showWindows()
      }
    }
  }

  static func openWindow(withHandle handle: WindowOpenHandle) {
    NSWorkspace.shared.open(URL(forHandle: handle))
  }
}
