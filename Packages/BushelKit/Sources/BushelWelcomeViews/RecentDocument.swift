//
// RecentDocument.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelViewsCore
  import SwiftData
  import SwiftUI
  import UniformTypeIdentifiers

  #if canImport(OSLog)
    import OSLog
  #else
    import Logger
  #endif

  struct RecentDocument: Identifiable {
    let id: UUID
    let url: URL
    let name: String
    let path: String
    let text: String
    let updatedAt: Date

    internal init(id: UUID, url: URL, name: String, path: String, text: String, updatedAt: Date) {
      self.id = id
      self.url = url
      self.name = name
      self.path = path
      self.text = text
      self.updatedAt = updatedAt
    }
  }

  extension RecentDocument {
    init?(bookmarkData: BookmarkData, logger: Logger, using context: ModelContext) {
      guard let url = Self.fetchURL(forBookmark: bookmarkData, logger: logger, using: context) else {
        return nil
      }

      self.init(
        id: bookmarkData.bookmarkID,
        url: url,
        name: url.deletingPathExtension().lastPathComponent,
        path: url.path,
        text: url.abbreviatingWithTilde,
        updatedAt: bookmarkData.updatedAt
      )
    }

    static func fetchURL(
      forBookmark bookmark: BookmarkData,
      logger: Logger,
      using context: ModelContext
    ) -> URL? {
      let url: URL
      do {
        url = try bookmark.fetchURL(using: context, withURL: nil)
      } catch let error as NSError where error.code == 259 {
        logger.notice("Removing invalid bookmark: \(bookmark.path)")
        context.delete(bookmark)
        do {
          try context.save()
        } catch {
          logger.error("Unable to delete \(bookmark.path) error: \(error) ")
          assertionFailure(error: error)
        }
        return nil
      } catch {
        logger.error("Bookmark \(bookmark.path) error: \(error) ")
        assertionFailure(error: error)
        return nil
      }
      return url
    }

    func nameForURL(_ url: URL) -> String {
      url
        .deletingPathExtension()
        .lastPathComponent
    }

    func textForBookmark(_ bookmark: BookmarkData) -> String {
      #if os(macOS)
        url.abbreviatingWithTilde
      #else
        pathForBookmark(bookmark)
      #endif
    }
  }
#endif
