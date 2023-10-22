//
// RecentDocumentsListView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelData
  import SwiftData
  import SwiftUI

  struct RecentDocumentsListView<ItemView: View>: View {
    let recentDocumentsClearDate: Date?
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
        }
      }
      .onChange(of: self.bookmarks) { _, _ in
        object.updateBookmarks(self.bookmarks, using: self.context)
      }
      .onAppear {
        object.updateBookmarks(self.bookmarks, using: self.context)
      }
      .onChange(of: self.object.isEmpty) { _, newValue in
        self.isEmpty = newValue
      }
    }

    internal init(
      recentDocumentsClearDate: Date?,
      isEmpty: Binding<Bool>,
      bookmarksQuery: Query<Array<BookmarkData>.Element, [BookmarkData]>? = nil,
      object: RecentDocumentsObject = RecentDocumentsObject(),
      forEach: @escaping (RecentDocument) -> ItemView
    ) {
      self._bookmarks = Self.queryBasedOn(
        recentDocumentsClearDate: recentDocumentsClearDate,
        overrideWith: bookmarksQuery
      )
      self.recentDocumentsClearDate = recentDocumentsClearDate
      self._isEmpty = isEmpty
      self._object = .init(wrappedValue: object)
      self.forEach = forEach
    }

    static func queryBasedOn(
      recentDocumentsClearDate: Date?,
      overrideWith other: Query<Array<BookmarkData>.Element, [BookmarkData]>? = nil
    ) -> Query<Array<BookmarkData>.Element, [BookmarkData]> {
      if let other {
        return other
      }
      let sort = \BookmarkData.updatedAt
      let order = SortOrder.reverse

      let filter: Predicate<BookmarkData>? = recentDocumentsClearDate.map { date in
        #Predicate { $0.updatedAt > date }
      }

      return Query(filter: filter, sort: sort, order: order)
    }
  }

#endif
