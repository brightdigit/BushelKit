//
// NewFilePanel.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit
  import BushelCore
  import Foundation
  import SwiftUI
  import UniformTypeIdentifiers

  public struct NewFilePanel<FileType: InitializableFileTypeSpecification> {
    public init() {}

    public init(_: FileType.Type) {}

    public func callAsFunction(with openWindow: OpenWindowAction) {
      let openPanel = NSSavePanel()
      openPanel.allowedContentTypes = [UTType(fileType: FileType.fileType)]
      openPanel.isExtensionHidden = true
      openPanel.begin { response in
        guard let fileURL = openPanel.url, response == .OK else {
          return
        }
        let value: FileType.WindowValueType
        do {
          value = try FileType.createAt(fileURL)
        } catch {
          openPanel.presentError(error)
          return
        }
        openWindow(value: value)
      }
    }
  }

  public extension OpenWindowAction {
    func callAsFunction(newFileOf valueType: (some InitializableFileTypeSpecification).Type) {
      NewFilePanel(valueType)(with: self)
    }
  }

#endif
