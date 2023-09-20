//
// RecentDocumentsMenu.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public struct RecentDocumentsMenu: View {
    let recentDocumentsClearDate: Date?
    let clearMenu: () -> Void
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openFileURL) private var openFileURL
    @State var isEmpty = false
    public var body: some View {
      Menu("Open Recent") {
        if !isEmpty {
          RecentDocumentsList(
            recentDocumentsClearDate: recentDocumentsClearDate,
            isEmpty: self.$isEmpty
          ) { document in
            Button {
              openFileURL(document.url, with: openWindow)
            } label: {
              Image(nsImage: NSWorkspace.shared.icon(forFile: document.path))
              Text(document.url.lastPathComponent)
            }
          }

          Divider()
        }
        Button("Clear Menu") {
          clearMenu()
        }.disabled(self.isEmpty)
      }
    }
  }
#endif
