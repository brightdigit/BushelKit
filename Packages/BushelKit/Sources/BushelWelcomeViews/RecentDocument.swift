//
// RecentDocument.swift
// Copyright (c) 2024 BrightDigit.
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
    init?(
      bookmarkData: BookmarkData,
      logger: Logger,
      using database: any Database,
      fileManager: FileManager = .default
    ) async {
      let bookmarkID = bookmarkData.bookmarkID
      let updatedAt = bookmarkData.updatedAt
      guard let url = await Self.fetchURL(forBookmark: bookmarkData, logger: logger, using: database) else {
        return nil
      }

      do {
        guard try fileManager.relationship(of: .trashDirectory, toItemAt: url) == .other else {
          return nil
        }
      } catch {
        logger.error("Unable to determine relationship for \(url): \(error.localizedDescription)")
        assertionFailure(error: error)
        return nil
      }

      self.init(
        id: bookmarkID,
        url: url,
        name: url.deletingPathExtension().lastPathComponent,
        path: url.path,
        text: url.abbreviatingWithTilde,
        updatedAt: updatedAt
      )
    }

    static func fetchURL(
      forBookmark originBookmark: BookmarkData,
      logger: Logger,
      using database: any Database
    ) async -> URL? {
      let url: URL

      let bookmark: BookmarkData
      do {
        bookmark = try await database.switchContextFor(model: originBookmark)
      } catch {
        logger.error("Unable to switch context with database.")
        assertionFailure(error: error)
        return nil
      }
      do {
        url = try await bookmark.fetchURL(using: database, withURL: nil)
      } catch let error as NSError where error.code == 259 {
        logger.notice("Removing invalid bookmark: \(bookmark.path)")
        await database.delete(bookmark)
        do {
          try await database.save()
        } catch {
          logger.error("Unable to delete \(bookmark.path) error: \(error) ")
          assertionFailure(error: error)
        }
        return nil
      } catch let error as NSError where error.code == 4 && error.domain == NSCocoaErrorDomain {
        logger.notice("Removing file doesn't exist bookmark: \(bookmark.path)")
        await database.delete(bookmark)
        do {
          try await database.save()
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
