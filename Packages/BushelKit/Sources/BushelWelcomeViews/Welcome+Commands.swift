//
// Welcome+Commands.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelData
  import BushelViewsCore
  import SwiftData
  import SwiftUI

  extension Date: RawRepresentable {
    static let millisecondsInSeconds: TimeInterval = 1000

    public init?(rawValue: Int) {
      self.init(timeIntervalSince1970: TimeInterval(rawValue) / Self.millisecondsInSeconds)
    }

    public var rawValue: Int {
      Int(self.timeIntervalSince1970 * Self.millisecondsInSeconds)
    }

    public typealias RawValue = Int
  }

  public enum Welcome {
    public struct WindowCommands: View {
      public init() {}

      @Environment(\.openWindow) private var openWindow
      public var body: some View {
        Button("Welcome to Bushel") {
          openWindow(value: WelcomeView.Value.default)
        }
      }
    }

    public struct RecentDocumentsMenu: View {
//      internal init(
//        recentDocumentsClearDate: Date?,
//        clearMenu: @escaping () -> Void,
//        object: WelcomeRecentDocumentsObject = WelcomeRecentDocumentsObject(),
//        _bookmarks: Query<Array<BookmarkData>.Element, [BookmarkData]>? = nil
//      ) {
//        self.recentDocumentsClearDate = recentDocumentsClearDate
//        self.clearMenu = clearMenu
//        self.object = object
//        self._bookmarks = _bookmarks ?? Self.queryBasedOn(recentDocumentsClearDate: recentDocumentsClearDate)
//      }

//      static func queryBasedOn(recentDocumentsClearDate: Date?) -> Query<Array<BookmarkData>.Element, [BookmarkData]> {
//        let sort = \BookmarkData.updatedAt
//        let order = SortOrder.reverse
//
//        let filter: Predicate<BookmarkData>? = recentDocumentsClearDate.map { date in
//          #Predicate { $0.updatedAt > date }
//        }
//
//        return Query(filter: filter, sort: sort, order: order)
//      }

      let recentDocumentsClearDate: Date?
      let clearMenu: () -> Void
      @Environment(\.openWindow) private var openWindow
      @Environment(\.openFileURL) private var openFileURL
      @State var isEmpty = false
      // @Environment(\.allowedOpenFileTypes) private var allowedOpenFileTypes

      public var body: some View {
        Menu("Open Recent") {
          if !isEmpty {
            RecentDocumentsListView(recentDocumentsClearDate: recentDocumentsClearDate, isEmpty: self.$isEmpty) { document in
              Button {
                openFileURL(document.url, with: openWindow)
              } label: {
                Image(nsImage: NSWorkspace.shared.icon(forFile: document.path))
                Text(document.url.lastPathComponent)
              }
            }

            Divider()
          }
          Button("Clear Menu") {
            clearMenu()
          }.disabled(self.isEmpty)
        }
      }
    }

    public struct OpenCommands: View {
      public init() {}

      @AppStorage("recentDocumentsClearDate") private var recentDocumentsClearDate: Date?
      @Environment(\.openWindow) private var openWindow
      @Environment(\.openFileURL) private var openFileURL
      @Environment(\.allowedOpenFileTypes) private var allowedOpenFileTypes

      public var body: some View {
        Button("Open...") {
          openFileURL(ofFileTypes: allowedOpenFileTypes, using: openWindow)
        }
        RecentDocumentsMenu(recentDocumentsClearDate: recentDocumentsClearDate) {
          recentDocumentsClearDate = .init()
        }
      }
    }
  }
#endif
