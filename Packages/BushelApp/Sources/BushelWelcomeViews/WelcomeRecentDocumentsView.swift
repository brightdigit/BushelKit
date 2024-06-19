//
// WelcomeRecentDocumentsView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelAccessibility
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelViewsCore
  import SwiftData
  import SwiftUI

  internal struct WelcomeRecentDocumentsView: View, Loggable {
    let recentDocumentsTypeFilter: DocumentTypeFilter
    let recentDocumentsClearDate: Date?
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast

    @State var isEmpty = false

    var body: some View {
      ZStack {
        List {
          RecentDocumentsList(
            publisherID: "welcome",
            isEmpty: self.$isEmpty
          ) { document in
            RecentDocumentItemButton(document: document)
          }
        }
        .listStyle(SidebarListStyle())
        .padding(-20)
        .isHidden(isEmpty)

        Text(.welcomeNoRecentDocuments)
          .opacity(colorSchemeContrast == .standard ? 0.75 : 1.0)
          .isHidden(!isEmpty)
      }
    }
  }
#endif
