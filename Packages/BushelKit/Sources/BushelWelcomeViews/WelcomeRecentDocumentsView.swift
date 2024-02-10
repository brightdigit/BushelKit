//
// WelcomeRecentDocumentsView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelViewsCore
  import SwiftData
  import SwiftUI

  struct WelcomeRecentDocumentsView: View, Loggable {
    let recentDocumentsTypeFilter: DocumentTypeFilter
    let recentDocumentsClearDate: Date?
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
              recentDocumentsTypeFilter: recentDocumentsTypeFilter,
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
