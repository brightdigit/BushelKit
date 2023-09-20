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
    internal init(fileTypes: [FileType]) {
      assert(!fileTypes.isEmpty)
      self.fileTypes = fileTypes
    }

    let fileTypes: [FileType]

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

  private struct AllowedOpenFileTypesKeys: EnvironmentKey {
    static let defaultValue = [FileType]()

    typealias Value = [FileType]
  }

  public extension EnvironmentValues {
    var allowedOpenFileTypes: [FileType] {
      get { self[AllowedOpenFileTypesKeys.self] }
      set { self[AllowedOpenFileTypesKeys.self] = newValue }
    }
  }

  public extension View {
    func allowedOpenFileTypes(
      _ fileTypes: [FileType]
    ) -> some View {
      self.environment(\.allowedOpenFileTypes, fileTypes)
    }
  }

  public extension Scene {
    func allowedOpenFileTypes(
      _ fileTypes: [FileType]
    ) -> some Scene {
      self.environment(\.allowedOpenFileTypes, fileTypes)
    }
  }

#endif
