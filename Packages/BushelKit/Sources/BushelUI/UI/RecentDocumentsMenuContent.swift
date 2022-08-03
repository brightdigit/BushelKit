//
// RecentDocumentsMenuContent.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
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

struct RecentDocumentsMenuContent: View {
  internal init(recentDocumentURLs: [URL] = [], isPreview: Bool = false) {
    _object = .init(wrappedValue: .init(recentDocumentURLs: recentDocumentURLs, isPreview: isPreview))
  }

  @StateObject var object: RecentDocumentsObject
  var body: some View {
    ForEach(object.recentDocumentURLs, id: \.self) { url in
      Button {
        Windows.openDocumentAtURL(url)
      } label: {
        Text(url.lastPathComponent)
        Image(nsImage: NSWorkspace.shared.icon(forFile: url.path))
      }
    }
  }
}

struct RecentDocumentsMenuContent_Previews: PreviewProvider {
  static var previews: some View {
    RecentDocumentsMenuContent(recentDocumentURLs: [
      .init(fileURLWithPath: "/Volumes/Media/hello copy.bshvm"),
      .init(fileURLWithPath: "/Volumes/Media/RestoreImages.bshrilib")
    ], isPreview: true)
  }
}
