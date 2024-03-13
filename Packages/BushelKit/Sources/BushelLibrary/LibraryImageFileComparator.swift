//
// LibraryImageFileComparator.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

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
