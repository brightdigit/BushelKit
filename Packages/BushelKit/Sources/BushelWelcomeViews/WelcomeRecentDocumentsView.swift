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
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    @State var isEmpty = false

    var body: some View {
      Group {
        if isEmpty {
          Text(.welcomeNoRecentDocuments)
            .opacity(colorSchemeContrast == .standard ? 0.75 : 1.0)
        } else {
          List {
            RecentDocumentsList(
              recentDocumentsClearDate: recentDocumentsClearDate,
              isEmpty: self.$isEmpty
            ) { document in
              RecentDocumentItemButton(document: document)
            }
          }.listStyle(SidebarListStyle()).padding(-20)
        }
      }
    }
  }
#endif
