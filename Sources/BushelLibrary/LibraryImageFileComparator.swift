//
//  LibraryImageFileComparator.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

/// A comparator for `LibraryImageFile` objects.
public struct LibraryImageFileComparator: SortComparator, Hashable, Sendable {
  /// The type of object being compared.
  public typealias Compared = LibraryImageFile

  /// The fields that can be used for comparison.
  public enum Field: Equatable, Sendable {
    /// The operating system build version.
    case operatingSystemBuild
  }

  /// The default `LibraryImageFileComparator` instance.
  public static let `default` = LibraryImageFileComparator()

  /// The sort order.
  public var order: SortOrder
  /// The field to use for comparison.
  public var field: Field

  /// Initializes a `LibraryImageFileComparator`.
  ///
  /// - Parameters:
  ///   - order: The sort order.
  ///   - field: The field to use for comparison.
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

  /// Compares two `LibraryImageFile` objects.
  ///
  /// - Parameters:
  ///   - lhs: The first `LibraryImageFile` object to compare.
  ///   - rhs: The second `LibraryImageFile` object to compare.
  /// - Returns: The comparison result.
  public func compare(
    _ lhs: BushelLibrary.LibraryImageFile,
    _ rhs: BushelLibrary.LibraryImageFile
  ) -> ComparisonResult {
    switch self.field {
    case .operatingSystemBuild:
      Self.compareByOperatingSystemBuild(lhs, rhs, order: self.order)
    }
  }
}
