//
//  SortComparator+Linux.swift
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

#if canImport(FoundationNetworking)
  // swiftlint:disable all
  public import Foundation

  // swift-format-ignore
  /// A comparison algorithm for a given type.
  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  public protocol SortComparator<Compared>: Hashable {
    /// The type that the `SortComparator` provides a comparison for.
    associatedtype Compared

    /// The relative ordering of lhs, and rhs.
    ///
    /// The result of comparisons should be flipped if the current `order`
    /// is `reverse`.
    ///
    /// If `compare(lhs, rhs)` is `.orderedAscending`, then `compare(rhs, lhs)`
    /// must be `.orderedDescending`. If `compare(lhs, rhs)` is
    /// `.orderedDescending`, then `compare(rhs, lhs)` must be
    /// `.orderedAscending`.
    ///
    /// - Parameters:
    ///     - lhs: A value to compare.
    ///     - rhs: A value to compare.
    func compare(_ lhs: Compared, _ rhs: Compared) -> ComparisonResult

    /// If the `SortComparator`s resulting order is forward or reverse.
    var order: SortOrder { get set }
  }

  /// The orderings that sorts can be performed with.
  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  @frozen
  public enum SortOrder: Hashable, Codable, Sendable {
    /// The ordering where if compare(a, b) == .orderedAscending,
    /// a is placed before b.
    case forward
    /// The ordering where if compare(a, b) == .orderedAscending,
    /// a is placed after b.
    case reverse

    public init(from decoder: any Decoder) throws {
      let container = try decoder.singleValueContainer()
      let isForward = try container.decode(Bool.self)
      if isForward {
        self = .forward
      } else {
        self = .reverse
      }
    }

    public func encode(to encoder: any Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .forward: try container.encode(true)
      case .reverse: try container.encode(false)
      }
    }
  }

  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  extension ComparisonResult {
    package func withOrder(_ order: SortOrder) -> ComparisonResult {
      if order == .reverse {
        if self == .orderedAscending { return .orderedDescending }
        if self == .orderedDescending { return .orderedAscending }
      }
      return self
    }
  }

  // swift-format-ignore
  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  package struct AnySortComparator: SortComparator {
    var _base: Any // internal for testing

    private var hashableBase: AnyHashable

    /// Takes `base` and two values to be compared and compares the two values
    /// using `base`.
    private let _compare: (Any, Any, Any) -> ComparisonResult

    /// Takes `base` inout, and a new `SortOrder` and changes `base`s `order`
    /// to match the new `SortOrder`.
    private let setOrder: (inout Any, SortOrder) -> AnyHashable

    /// Gets the current `order` property of `base`.
    private let getOrder: (Any) -> SortOrder

    package init<Comparator: SortComparator>(_ comparator: Comparator) {
      self.hashableBase = AnyHashable(comparator)
      self._base = comparator
      self._compare = { (base: Any, lhs: Any, rhs: Any) -> ComparisonResult in
        (base as! Comparator).compare(lhs as! Comparator.Compared, rhs as! Comparator.Compared)
      }
      self.setOrder = { (base: inout Any, newOrder: SortOrder) -> AnyHashable in
        var typedBase = base as! Comparator
        typedBase.order = newOrder
        base = typedBase
        return AnyHashable(typedBase)
      }
      self.getOrder = { (base: Any) -> SortOrder in
        (base as! Comparator).order
      }
    }

    package var order: SortOrder {
      get {
        self.getOrder(self._base)
      }
      set {
        self.hashableBase = self.setOrder(&self._base, newValue)
      }
    }

    package func compare(_ lhs: Any, _ rhs: Any) -> ComparisonResult {
      self._compare(self._base, lhs, rhs)
    }

    package func hash(into hasher: inout Hasher) {
      hasher.combine(self.hashableBase)
    }

    package static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.hashableBase == rhs.hashableBase
    }
  }

  /// Compares `Comparable` types using their comparable implementation.
  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  public struct ComparableComparator<Compared: Comparable>: SortComparator, Sendable {
    public var order: SortOrder

    // No need for availability on this initializer in the package.
    public init(order: SortOrder = .forward) {
      self.order = order
    }

    private func unorderedCompare(_ lhs: Compared, _ rhs: Compared) -> ComparisonResult {
      if lhs < rhs { return .orderedAscending }
      if lhs > rhs { return .orderedDescending }
      return .orderedSame
    }

    public func compare(_ lhs: Compared, _ rhs: Compared) -> ComparisonResult {
      self.unorderedCompare(lhs, rhs).withOrder(self.order)
    }
  }

  /// A comparator which orders optional values using a comparator which
  /// compares the optional's `Wrapped` type. `nil` values are ordered before
  /// non-nil values when `order` is `forward`.
  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  package struct OptionalComparator<Base: SortComparator>: SortComparator {
    private var base: Base

    package init(_ base: Base) {
      self.base = base
    }

    package var order: SortOrder {
      get { self.base.order }
      set { self.base.order = newValue }
    }

    package func compare(_ lhs: Base.Compared?, _ rhs: Base.Compared?) -> ComparisonResult {
      guard let lhs else {
        if rhs == nil { return .orderedSame }
        return .orderedAscending.withOrder(self.order)
      }
      guard let rhs else { return .orderedDescending.withOrder(self.order) }
      return self.base.compare(lhs, rhs)
    }
  }

  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  extension Never: SortComparator {
    public typealias Compared = Never

    public func compare(_: Never, _: Never) -> ComparisonResult {}

    public var order: SortOrder {
      get {
        switch self {}
      }
      set {
        switch self {}
      }
    }
  }

  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  extension Sequence {
    /// Returns the elements of the sequence, sorted using the given comparator
    /// to compare elements.
    ///
    /// - Parameters:
    ///   - comparator: the comparator to use in ordering elements
    /// - Returns: an array of the elements sorted using `comparator`.
    public func sorted<Comparator: SortComparator>(using comparator: Comparator) -> [Element]
    where Comparator.Compared == Element {
      self.sorted {
        comparator.compare($0, $1) == .orderedAscending
      }
    }

    /// Returns the elements of the sequence, sorted using the given array of
    /// `SortComparator`s to compare elements.
    ///
    /// - Parameters:
    ///   - comparators: an array of comparators used to compare elements. The
    ///   first comparator specifies the primary comparator to be used in
    ///   sorting the sequence's elements. Any subsequent comparators are used
    ///   to further refine the order of elements with equal values.
    /// - Returns: an array of the elements sorted using `comparators`.
    public func sorted<Comparator: SortComparator>(using comparators: some Sequence<Comparator>)
      -> [Element]
    where
      Element == Comparator.Compared
    {
      self.sorted {
        comparators.compare($0, $1) == .orderedAscending
      }
    }
  }

  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  extension Sequence {
    /// If `lhs` is ordered before `rhs` in the ordering described by the given
    /// sequence of `SortComparator`s
    ///
    /// The first element of the sequence of comparators specifies the primary
    /// comparator to be used in sorting the sequence's elements. Any subsequent
    /// comparators are used to further refine the order of elements with equal
    /// values.
    public func compare<Comparator: SortComparator>(
      _ lhs: Comparator.Compared, _ rhs: Comparator.Compared
    ) -> ComparisonResult where Element == Comparator {
      for comparator in self {
        let result = comparator.compare(lhs, rhs)
        if result != .orderedSame { return result }
      }
      return .orderedSame
    }
  }

  @available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
  extension MutableCollection where Self: RandomAccessCollection {
    /// Sorts the collection using the given comparator to compare elements.
    /// - Parameters:
    ///     - comparator: the sort comparator used to compare elements.
    public mutating func sort<Comparator: SortComparator>(using comparator: Comparator)
    where Comparator.Compared == Element {
      self.sort {
        comparator.compare($0, $1) == .orderedAscending
      }
    }

    /// Sorts the collection using the given array of `SortComparator`s to
    /// compare elements.
    ///
    /// - Parameters:
    ///   - comparators: an array of comparators used to compare elements. The
    ///   first comparator specifies the primary comparator to be used in
    ///   sorting the sequence's elements. Any subsequent comparators are used
    ///   to further refine the order of elements with equal values.
    public mutating func sort<Comparator: SortComparator>(
      using comparators: some Sequence<Comparator>
    ) where Element == Comparator.Compared {
      self.sort {
        comparators.compare($0, $1) == .orderedAscending
      }
    }
  }

#endif
// swiftlint:enable all
