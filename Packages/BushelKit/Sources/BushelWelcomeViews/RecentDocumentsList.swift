//
// RecentDocumentsList.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelData
  import SwiftData
  import SwiftUI

  struct RecentDocumentsList<ItemView: View>: View {
    let recentDocumentsClearDate: Date
    let recentDocumentsTypeFilter: DocumentTypeFilter

    @Binding var isEmpty: Bool
    @Query var bookmarks: [BookmarkData]
    @Environment(\.modelContext) private var context
    @State var object = RecentDocumentsObject()

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
      .onChange(of: self.bookmarks) { _, _ in
        object.updateBookmarks(self.bookmarks, using: self.context)
      }
      .onAppear {
        object.updateBookmarks(self.bookmarks, using: self.context)
        self.isEmpty = object.isEmpty
      }
      .onChange(of: self.object.isEmpty) { _, newValue in
        self.isEmpty = newValue
      }
    }

    internal init(
      recentDocumentsClearDate: Date?,
      recentDocumentsTypeFilter: DocumentTypeFilter,
      isEmpty: Binding<Bool>,
      bookmarksQuery: Query<Array<BookmarkData>.Element, [BookmarkData]>? = nil,
      object: RecentDocumentsObject = RecentDocumentsObject(),
      forEach: @escaping (RecentDocument) -> ItemView
    ) {
      let recentDocumentsClearDate = recentDocumentsClearDate ?? .distantPast
      self._bookmarks = bookmarksQuery ??
        Self.queryBasedOn(
          recentDocumentsTypeFilter: recentDocumentsTypeFilter,
          recentDocumentsClearDate: recentDocumentsClearDate
        )
      self.recentDocumentsClearDate = recentDocumentsClearDate
      self.recentDocumentsTypeFilter = recentDocumentsTypeFilter
      self._isEmpty = isEmpty
      self._object = .init(wrappedValue: object)
      self.forEach = forEach
    }

    static func queryBasedOn(
      recentDocumentsTypeFilter: DocumentTypeFilter,
      recentDocumentsClearDate: Date
    ) -> Query<Array<BookmarkData>.Element, [BookmarkData]> {
      let sort = \BookmarkData.updatedAt
      let order = SortOrder.reverse
      let filter: Predicate<BookmarkData>
      let searchStrings = recentDocumentsTypeFilter.searchStrings
      if let libraryFilter = searchStrings.first {
        filter = #Predicate {
          $0.updatedAt > recentDocumentsClearDate && !$0.path.localizedStandardContains(libraryFilter)
        }
      } else {
        filter = #Predicate {
          $0.updatedAt > recentDocumentsClearDate
        }
      }

      return Query(filter: filter, sort: sort, order: order)
    }
  }

#endif
