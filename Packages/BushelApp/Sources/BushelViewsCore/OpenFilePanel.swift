//
// OpenFilePanel.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit

  public import BushelCore

  public import Foundation

  public import SwiftUI

  public import UniformTypeIdentifiers

  public struct OpenFilePanel<FileType: FileTypeSpecification>: Sendable {
    public init() {}

    public init(_: FileType.Type) {}

    @MainActor
    public func callAsFunction(with openWindow: OpenWindowAction) {
      let openPanel = NSOpenPanel()
      openPanel.allowedContentTypes = [UTType(fileType: FileType.fileType)]
      openPanel.isExtensionHidden = true
      openPanel.begin { response in
        guard let fileURL = openPanel.url, response == .OK else {
          #warning("logging-note: should we log something here?")
          return
        }
        let libraryFile = DocumentFile<FileType>(url: fileURL)
        openWindow(value: libraryFile)
      }
    }
  }

  extension OpenWindowAction {
    @MainActor public func callAsFunction(_ valueType: (some FileTypeSpecification).Type) {
      OpenFilePanel(valueType)(with: self)
    }
  }

#endif
