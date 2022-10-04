//
// RecentDocumentsObject.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(AppKit) && canImport(SwiftUI)
  import AppKit
  import Foundation

  class RecentDocumentsObject: ObservableObject {
    init(recentDocumentURLs _: [URL] = [], isPreview: Bool = false) {
      recentDocumentURLs = []

      guard !isPreview else {
        return
      }
      DispatchQueue.main.async {
        let controller = NSDocumentController.shared
        self.controller = controller
        self.recentDocumentURLs = controller.recentDocumentURLs
        controller.publisher(
          for: \.recentDocumentURLs
        )
        .receive(
          on: DispatchQueue.main
        )
        .assign(to: &self.$recentDocumentURLs)
      }
    }

    @Published var recentDocumentURLs: [URL]

    // swiftlint:disable:next implicitly_unwrapped_optional
    var controller: NSDocumentController!
  }
#endif