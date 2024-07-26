//
// BookmarkEventMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  public import BushelDataCore

  public import BushelDataMonitor

  public import BushelLogging

  public import Foundation
  import SwiftData

  internal actor BookmarkEventMetadata: Loggable {
    static var loggingCategory: BushelLogging.Category {
      .data
    }

    let id: PersistentIdentifier
    let url: URL
    var object: (any DispatchSourceFileSystemObject)?

    internal init?(id: PersistentIdentifier, url: URL) {
      self.id = id
      self.url = url
    }

    static func createFileSystemSource(url: URL) -> DispatchSourceFileSystemObject? {
      guard url.startAccessingSecurityScopedResource() else {
        return nil
      }
      let fileDescriptor = open(url.path, O_EVTONLY)
      guard fileDescriptor > 0 else {
        return nil
      }
      Self.logger.debug("Created Dispatch Source")
      return DispatchSource.makeFileSystemObjectSource(
        fileDescriptor: fileDescriptor,
        eventMask: [.delete, .rename]
      )
    }

    func cancel() {
      url.stopAccessingSecurityScopedResource()
      self.object?.cancel()
    }

    func setEventHandler(_ closure: @Sendable @escaping (BookmarkEventMetadata) -> Void) {
      let object = self.object ?? Self.createFileSystemSource(url: self.url)
      assert(object != nil)
      guard let object else {
        Self.logger.error("Unable to create source for \(self.url)")
        return
      }
      object.setEventHandler {
        Self.logger.debug("Event Occured for \(self.url)")
        closure(self)
      }
      self.object = object
      object.activate()
      Self.logger.debug("Event Handler Setup for \(self.url)")
    }

    deinit {}
  }
#endif
