//
//  LibraryImageFileComparator.swift
//  BushelKit
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

public import Foundation

public struct LibraryImageFileComparator: SortComparator, Hashable, Sendable {
  public typealias Compared = LibraryImageFile
  public enum Field: Equatable, Sendable {
    case operatingSystemBuild
  }

  public static let `default` = LibraryImageFileComparator()

  public var order: SortOrder
  public var field: Field

  public init(
    order: SortOrder = .forward,
    field: LibraryImageFileComparator.Field = .operatingSystemBuild
  ) {
    self.order = order
    self.field = field
  }

  private static func compareByOperatingSystemBuild(
    _ lhs: BushelLibrary.LibraryImageFile,
    _ rhs: BushelLibrary.LibraryImageFile,
    order: SortOrder
  ) -> ComparisonResult {
    if lhs.metadata.operatingSystemVersion == rhs.metadata.operatingSystemVersion {
      let lhsBuild = lhs.metadata.buildVersion ?? ""
      let rhsBuild = rhs.metadata.buildVersion ?? ""
      return lhsBuild.caseInsensitiveCompare(rhsBuild)
    } else if lhs.metadata.operatingSystemVersion < rhs.metadata.operatingSystemVersion {
      return order == .forward ? .orderedAscending : .orderedDescending
    } else {
      return order == .forward ? .orderedDescending : .orderedAscending
    }
  }

  public func compare(
    _ lhs: BushelLibrary.LibraryImageFile,
    _ rhs: BushelLibrary.LibraryImageFile
  ) -> ComparisonResult {
    switch self.field {
    case .operatingSystemBuild:
      Self.compareByOperatingSystemBuild(lhs, rhs, order: order)
    }
  }
}
