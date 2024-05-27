//
// BookmarkMonitor.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import FeatherQuill
  import SwiftUI

  public struct BookmarkMonitor: BushelFeatureFlag {
    public typealias UserTypeValue = UserAudience

    public static let probability: Double = 0.25
    public static let initialValue = false
  }

  extension EnvironmentValues {
    @available(*, unavailable, message: "Not ready yet.")
    public var bookmarkMonitor: BookmarkMonitor.Feature { self[BookmarkMonitor.self] }
  }
#endif
