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
    let recentDocumentsClearDate: Date?
    @Environment(\.modelContext) private var context
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openFileURL) private var openFileURL
    @State var isEmpty = false

    var body: some View {
      Group {
        // if let recentDocuments = object.recentDocuments {
        if isEmpty {
          Text(.welcomeNoRecentDocuments).opacity(0.5)
        } else {
          List {
            RecentDocumentsListView(recentDocumentsClearDate: recentDocumentsClearDate, isEmpty: self.$isEmpty) { document in
              RecentDocumentItemButton(document: document)
            }
//              ForEach(recentDocuments) { document in
//                RecentDocumentItemButton(document: document)
//              }
          }.listStyle(SidebarListStyle()).padding(-20)
        }
//        } else {
//          Text(.welcomeUpdatingRecentDocuments)
//        }
      }
    }
  }
#endif
