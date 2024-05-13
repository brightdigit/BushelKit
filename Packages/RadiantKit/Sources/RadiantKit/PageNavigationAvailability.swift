//
//  PageNavigationAvailability.swift
//  RadiantKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#if canImport(SwiftUI)
  import Foundation
  import SwiftUI

  private struct PageNavigationAvailabilityKey: EnvironmentKey, Sendable {
    static let defaultValue: PageNavigationAvailability = .default
  }

  public struct PageNavigationAvailability: OptionSet, Sendable {
    public typealias RawValue = Int
    public static let `default`: PageNavigationAvailability = .none

    public static let none: PageNavigationAvailability = .init()
    public static let next: PageNavigationAvailability = .init(rawValue: 1)
    public static let previous: PageNavigationAvailability = .init(rawValue: 2)
    public static let both: PageNavigationAvailability = [previous, next]

    public let rawValue: Int

    public init(rawValue: RawValue) {
      assert(rawValue < 4)
      self.rawValue = rawValue
    }
  }

  extension EnvironmentValues {
    public var pageNavigationAvailability: PageNavigationAvailability {
      get { self[PageNavigationAvailabilityKey.self] }
      set {
        self[PageNavigationAvailabilityKey.self] = newValue
      }
    }
  }
#endif
