//
// PageNavigationAvailability.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  private struct PageNavigationAvailabilityKey: EnvironmentKey, Sendable {
    static let defaultValue: PageNavigationAvailability = .default
  }

  public struct PageNavigationAvailability: OptionSet, Sendable {
    public typealias RawValue = Int
    static let `default`: PageNavigationAvailability = .none

    static let none: PageNavigationAvailability = .init()
    static let next: PageNavigationAvailability = .init(rawValue: 1)
    static let previous: PageNavigationAvailability = .init(rawValue: 2)
    static let both: PageNavigationAvailability = [previous, next]

    public let rawValue: Int

    public init(rawValue: RawValue) {
      assert(rawValue < 4)
      self.rawValue = rawValue
    }
  }

  public extension EnvironmentValues {
    var pageNavigationAvailability: PageNavigationAvailability {
      get { self[PageNavigationAvailabilityKey.self] }
      set {
        self[PageNavigationAvailabilityKey.self] = newValue
      }
    }
  }
#endif
