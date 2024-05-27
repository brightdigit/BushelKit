//
// RecentDocumentsList.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelData
  import BushelDataMonitor
  import BushelLogging
  import Combine
  import SwiftData
  import SwiftUI

  @MainActor
  internal struct RecentDocumentsList<ItemView: View>: View, Loggable {
    let publisherID: String

    @Binding var isEmpty: Bool
    @Environment(\.databaseChangePublicist) private var createDbPublisher
    @Environment(\.database) private var database
    @State var object: RecentDocumentsObject

    let forEach: (RecentDocument) -> ItemView

    var body: some View {
      Group {
        if let recentDocuments = object.recentDocuments {
          ForEach(recentDocuments) { document in
            self.forEach(document)
          }
        } else {
          ProgressView()
        }
      }
      .onReceive(self.object.dbPublisher, perform: { update in
        Self.logger.debug("Received Update For \(self.publisherID)")
        object.updateBookmarks(update, using: self.database)
      })
      .onAppear {
        object.updateBookmarks(nil, using: self.database)
        self.object.beginPublishing {
          self.createDbPublisher(id: self.publisherID)
        }
        Self.logger.debug("Publsher List for \(publisherID)")
      }
      .onChange(of: self.object.isEmpty) { _, newValue in
        Self.logger.debug("EmptyCheck List for \(publisherID)")
        self.isEmpty = newValue
      }
      .onDisappear {
        Self.logger.debug("Disapear \(publisherID)")
      }
    }

    internal init(
      publisherID: String,
      recentDocumentsClearDate: Date?,
      recentDocumentsTypeFilter: DocumentTypeFilter,
      isEmpty: Binding<Bool>,
      forEach: @escaping (RecentDocument) -> ItemView
    ) {
      Self.logger.debug("Creating List for \(publisherID)")
      let recentDocumentsClearDate = recentDocumentsClearDate ?? .distantPast
      let object = RecentDocumentsObject(
        typeFilter: recentDocumentsTypeFilter,
        clearDate: recentDocumentsClearDate
      )
      self.publisherID = publisherID
      self._isEmpty = isEmpty
      self._object = .init(wrappedValue: object)
      self.forEach = forEach
    }
  }

#endif
