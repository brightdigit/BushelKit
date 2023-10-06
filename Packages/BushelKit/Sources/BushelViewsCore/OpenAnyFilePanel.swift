//
// OpenAnyFilePanel.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit
  import BushelCore
  import Foundation
  import SwiftUI
  import UniformTypeIdentifiers

  public struct OpenAnyFilePanel {
    let fileTypes: [FileType]

    internal init(fileTypes: [FileType]) {
      assert(!fileTypes.isEmpty)
      self.fileTypes = fileTypes
    }

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

  public extension OpenFileURLAction {
    func callAsFunction(ofFileTypes fileTypes: [FileType], using openWindow: OpenWindowAction) {
      OpenAnyFilePanel(fileTypes: fileTypes).callAsFunction(with: self, using: openWindow)
    }
  }

#endif
