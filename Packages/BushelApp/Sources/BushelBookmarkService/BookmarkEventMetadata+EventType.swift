//
// BookmarkEventMetadata+EventType.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import Foundation

  extension BookmarkEventMetadata {
    internal enum EventType: Sendable {
      case delete
      case rename
      case unknown(DispatchSource.FileSystemEvent.RawValue)

      init(event: DispatchSource.FileSystemEvent) {
        switch event {
        case .delete:
          self = .delete
        case .rename:
          self = .rename
        default:
          self = .unknown(event.rawValue)
        }
      }
    }

    var event: EventType? {
      (self.object?.data).map(EventType.init(event:))
    }
  }
#endif
