//
// RecentDocumentsMenu.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import SwiftUI

  public struct RecentDocumentsMenu: View {
    let recentDocumentsClearDate: Date?
    let recentDocumentsTypeFilter: DocumentTypeFilter
    let clearMenu: () -> Void
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openFileURL) private var openFileURL
    @State var isEmpty = false
    public var body: some View {
      Menu {
        if !isEmpty {
          RecentDocumentsList(
            publisherID: "menu",
            recentDocumentsClearDate: recentDocumentsClearDate,
            recentDocumentsTypeFilter: recentDocumentsTypeFilter,
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
      } label: {
        Text(.menuOpenRecent)
      }
    }
  }
#endif
