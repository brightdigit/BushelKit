//
// WelcomeRecentDocumentsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelViewsCore
  import SwiftData
  import SwiftUI
  import UniformTypeIdentifiers

  struct WelcomeRecentDocumentsView: View, LoggerCategorized {
    static let maxTimeIntervalSinceNow: TimeInterval = 5 * 60 * 60

    struct CachedURL {
      internal init(url: URL, timestamp: Date = Date()) {
        self.url = url
        self.timestamp = timestamp
      }

      let url: URL
      let timestamp: Date
    }

    @Query var bookmarks: [BookmarkData]
    @Environment(\.modelContext) private var context
    @State var urls = [UUID: CachedURL]()
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openFileURL) private var openFileURL

    func nameForBookmark(_ bookmark: BookmarkData) -> String {
      let url = urlForBookmark(bookmark) ?? URL(fileURLWithPath: bookmark.path)
      return url
        .deletingPathExtension()
        .lastPathComponent
    }

    func pathForBookmark(_ bookmark: BookmarkData) -> String {
      urlForBookmark(bookmark)?.path ?? bookmark.path
    }

    func textForBookmark(_ bookmark: BookmarkData) -> String {
      urlForBookmark(bookmark)?.abbreviatingWithTilde ?? URL(fileURLWithPath: bookmark.path).abbreviatingWithTilde
    }

    func urlForBookmark(_ bookmark: BookmarkData) -> URL? {
      if let cachedURL = urls[bookmark.bookmarkID] {
        guard cachedURL.timestamp.timeIntervalSinceNow < Self.maxTimeIntervalSinceNow else {
          defer {
            Task {
              self.urls.removeValue(forKey: bookmark.bookmarkID)
            }
          }
          return nil
        }
        return cachedURL.url
      }
      let url: URL
      do {
        url = try bookmark.fetchURL(using: context, withURL: nil)
      } catch let error as NSError where error.code == 259 {
        Self.logger.notice("Removing invalid bookmark: \(bookmark.path)")
        context.delete(bookmark)
        do {
          try context.save()
        } catch {
          Self.logger.error("Unable to delete \(bookmark.path) error: \(error) ")
          assertionFailure(error: error)
        }
        return nil
      } catch {
        Self.logger.error("Bookmark \(bookmark.path) error: \(error) ")
        assertionFailure(error: error)
        return nil
      }
      defer {
        Task {
          self.urls[bookmark.bookmarkID] = .init(url: url)
        }
      }
      return url
    }

    var body: some View {
      if bookmarks.isEmpty {
        Text("No Recent Machines").opacity(0.5)
      } else {
        List {
          ForEach(bookmarks, id: \.bookmarkID) { bookmark in
            if let url = urlForBookmark(bookmark) {
              Button {
                openFileURL(url, with: openWindow)
              } label: {
                HStack {
                  Image(nsImage: NSWorkspace.shared.icon(forFile: pathForBookmark(bookmark)))
                  VStack(alignment: .leading) {
                    Text(
                      nameForBookmark(bookmark)
                    )
                    .font(.system(size: 12.0))
                    .fontWeight(.medium)
                    Text(textForBookmark(bookmark)).font(.system(size: 10.0)).fontWeight(.ultraLight).lineLimit(1)
                  }.foregroundColor(.primary)
                  Spacer()
                }
              }.buttonStyle(BorderlessButtonStyle())
            }
          }
        }.listStyle(SidebarListStyle()).padding(-20)
      }
    }
  }
#endif
