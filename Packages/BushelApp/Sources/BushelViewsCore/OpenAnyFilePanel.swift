//
// OpenAnyFilePanel.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit

  public import BushelCore

  import Foundation

  public import SwiftUI

  import UniformTypeIdentifiers

  public struct OpenAnyFilePanel {
    let fileTypes: [FileType]

    internal init(fileTypes: [FileType]) {
      assert(!fileTypes.isEmpty)
      self.fileTypes = fileTypes
    }

    @MainActor
    public func callAsFunction(with openFileURL: OpenFileURLAction, using openWindow: OpenWindowAction) {
      let openPanel = NSOpenPanel()
      openPanel.allowedContentTypes = fileTypes.map(UTType.init(fileType:))
      openPanel.isExtensionHidden = true
      openPanel.begin { response in
        guard let fileURL = openPanel.url, response == .OK else {
          return
        }
        openFileURL(fileURL, with: openWindow)
      }
    }
  }

  extension OpenFileURLAction {
    @MainActor
    public func callAsFunction(ofFileTypes fileTypes: [FileType], using openWindow: OpenWindowAction) {
      OpenAnyFilePanel(fileTypes: fileTypes).callAsFunction(with: self, using: openWindow)
    }
  }

#endif
