//
// RecentDocument.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelViewsCore
  import DataThespian
  import SwiftData
  import SwiftUI
  import UniformTypeIdentifiers

  #if canImport(OSLog)
    import OSLog
  #else
    import Logger
  #endif
  internal struct RecentDocument: Identifiable, Sendable {
    let model: ModelID<BookmarkData>
    let url: URL
    let name: String
    let path: String
    let text: String
    let updatedAt: Date

    var id: PersistentIdentifier.ID {
      self.model.id
    }
  }

  extension RecentDocument {
    init?(
      bookmarkDataID: ModelID<BookmarkData>,
      logger: @Sendable @escaping @autoclosure () -> Logger,
      using database: any Database,
      fileManager: @Sendable () -> FileManager = { .default }
    ) async {
      let url: URL
      let updatedAt: Date
      let logger = logger()
      do {
        (url, updatedAt) = try await database.with(bookmarkDataID) {
          try ($0.fetchURL(), $0.updatedAt)
        }
      } catch {
        logger.error("Cannot access file: \(error.localizedDescription)")
        assertionFailure(error: error)
        return nil
      }

      do {
        guard try fileManager().relationship(of: .trashDirectory, toItemAt: url) == .other else {
          return nil
        }
      } catch {
        logger.error("Unable to determine relationship for \(url): \(error.localizedDescription)")
        assertionFailure(error: error)
        return nil
      }

      self.init(
        model: bookmarkDataID,
        url: url,
        name: url.deletingPathExtension().lastPathComponent,
        path: url.path,
        text: url.abbreviatingWithTilde,
        updatedAt: updatedAt
      )
    }

    static func fetchURL(
      forBookmark bookmark: ModelID<BookmarkData>,
      logger: Logger,
      using database: any Database
    ) async -> URL? {
      let url: URL
      do {
        url = try await database.with(bookmark) {
          try $0.fetchURL()
        }
      } catch let error as NSError where error.code == 259 {
        logger.notice("Removing invalid bookmark")
        await database.delete(bookmark)
        return nil
      } catch let error as NSError where error.code == 4 && error.domain == NSCocoaErrorDomain {
        logger.notice("Removing file doesn't exist bookmark")
        await database.delete(bookmark)

        return nil
      } catch {
        logger.error("Bookmark error: \(error) ")
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
