//
// WelcomeRecentDocumentsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelViewsCore
  import SwiftData
  import SwiftUI

  struct WelcomeRecentDocumentsView: View, LoggerCategorized {
    static let maxTimeIntervalSinceNow: TimeInterval = 5 * 60 * 60

    @State var object = WelcomeRecentDocumentsObject()
    @Query(sort: \BookmarkData.updatedAt, order: .reverse) var bookmarks: [BookmarkData]
    @Environment(\.modelContext) private var context
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openFileURL) private var openFileURL

    var body: some View {
      Group {
        if let recentDocuments = object.recentDocuments {
          if recentDocuments.isEmpty {
            Text(.welcomeNoRecentDocuments).opacity(0.5)
          } else {
            List {
              ForEach(recentDocuments) { document in
                RecentDocumentItemButton(document: document)
              }
            }.listStyle(SidebarListStyle()).padding(-20)
          }
        } else {
          Text(.welcomeUpdatingRecentDocuments)
        }
      }
      .onChange(of: self.bookmarks) { _, _ in
        object.updateBookmarks(self.bookmarks, using: self.context)
      }
      .onAppear {
        object.updateBookmarks(self.bookmarks, using: self.context)
      }
    }
  }
#endif
