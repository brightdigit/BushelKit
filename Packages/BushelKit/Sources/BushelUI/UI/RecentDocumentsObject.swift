//
// RecentDocumentsObject.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

import SwiftUI

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
      controller.publisher(for: \.recentDocumentURLs).receive(on: DispatchQueue.main).assign(to: &self.$recentDocumentURLs)
    }
  }

  @Published var recentDocumentURLs: [URL]
  var controller: NSDocumentController!
}
