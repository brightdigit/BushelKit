//
// NewFilePanel.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit

  public import BushelCore

  public import Foundation

  public import SwiftUI

  public import UniformTypeIdentifiers

  public struct NewFilePanel<FileType: InitializableFileTypeSpecification>: Sendable {
    public init() {}

    public init(_: FileType.Type) {}

    @MainActor
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

  extension OpenWindowAction {
    @MainActor
    public func callAsFunction(newFileOf valueType: (some InitializableFileTypeSpecification).Type) {
      NewFilePanel(valueType)(with: self)
    }
  }

#endif
