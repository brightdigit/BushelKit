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

    @AppStorage(for: RecentDocuments.TypeFilter.self) private var recentDocumentsTypeFilter
    @AppStorage(for: RecentDocuments.ClearDate.self) private var recentDocumentsClearDate
    @Environment(\.databaseChangePublicist) private var createDbPublisher
    @Environment(\.database) private var database
    @State var object: RecentDocumentsObject

    let clearTrigger: AnyPublisher<Void, Never>
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
      .onReceive(self.clearTrigger, perform: { _ in
        self.clear()
      })
      .onReceive(self.object.dbPublisher, perform: { update in
        Self.logger.debug("Received Update For \(self.publisherID)")
        object.updateBookmarks(update, using: self.database)
      })
      .onAppear {
        object.setup(
          clearDate: self.recentDocumentsClearDate,
          withFilter: self.recentDocumentsTypeFilter
        )
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
      .onChange(of: self.recentDocumentsClearDate) { _, newValue in
        self.object.setup(clearDate: newValue, withFilter: nil)
      }
      .onChange(of: self.recentDocumentsTypeFilter) { _, newValue in
        self.object.setup(clearDate: nil, withFilter: newValue)
      }
      .onDisappear {
        Self.logger.debug("Disapear \(publisherID)")
      }
    }

    internal init(
      publisherID: String,
      isEmpty: Binding<Bool>,
      clearTrigger: some Publisher<Void, Never>,
      forEach: @escaping (RecentDocument) -> ItemView
    ) {
      self.init(
        publisherID: publisherID,
        isEmpty: isEmpty,
        clearTrigger: clearTrigger.eraseToAnyPublisher(),
        forEach: forEach
      )
    }

    internal init(
      publisherID: String,
      isEmpty: Binding<Bool>,
      forEach: @escaping (RecentDocument) -> ItemView
    ) {
      let emptyPublisher = Empty<Void, Never>(completeImmediately: false).eraseToAnyPublisher()
      self.init(
        publisherID: publisherID,
        isEmpty: isEmpty,
        clearTrigger: emptyPublisher,
        forEach: forEach
      )
    }

    internal init(
      publisherID: String,
      isEmpty: Binding<Bool>,
      clearTrigger: AnyPublisher<Void, Never>,
      forEach: @escaping (RecentDocument) -> ItemView
    ) {
      Self.logger.debug("Creating List for \(publisherID)")
      let object = RecentDocumentsObject()
      self.publisherID = publisherID
      self._isEmpty = isEmpty
      self._object = .init(wrappedValue: object)
      self.forEach = forEach
      self.clearTrigger = clearTrigger
    }

    func clear() {
      recentDocumentsClearDate = Date()
    }
  }

#endif
