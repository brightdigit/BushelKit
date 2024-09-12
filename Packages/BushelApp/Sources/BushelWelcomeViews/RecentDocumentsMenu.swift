//
// RecentDocumentsMenu.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import Combine

  public import SwiftUI

  public struct RecentDocumentsMenu: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openFileURL) private var openFileURL
    @State var isEmpty = false
    let clearTrigger = PassthroughSubject<Void, Never>()
    public var body: some View {
      Menu {
        RecentDocumentsList(
          publisherID: "menu",
          isEmpty: self.$isEmpty,
          clearTrigger: clearTrigger
        ) { document in
          Button {
            openFileURL(document.url, with: openWindow)
          } label: {
            Image(nsImage: NSWorkspace.shared.icon(forFile: document.path))
            Text(document.url.lastPathComponent)
          }
        }

        if !isEmpty {
          Divider()
        }
        Button("Clear Menu") {
          clearTrigger.send()
        }.disabled(self.isEmpty)
      } label: {
        Text(.menuOpenRecent)
      }
    }
  }
#endif
