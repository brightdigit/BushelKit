//
//  Array.swift
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

internal import Foundation

#if canImport(SwiftUI)
  internal import SwiftUI
#endif

extension Array {
  /// Removes elements at the specified indices from the array.
  /// - Parameter array: The array to remove elements from.
  /// - Parameter offsets: The indices of the elements to remove.
  @Sendable
  public static func remove(from array: inout Self, atOffsets offsets: [Int]) {
    array.remove(atOffsets: offsets)
  }

  /// Returns an array of indices that expects the first element to be removed.
  /// - Parameter array: The array to get indices for.
  /// - Returns: An array of indices that expects the first element to be removed.
  @Sendable
  public static func indiciesExpectFirst(_ array: Self) -> [Int] {
    array.indiciesExpectFirst()
  }

  private func indiciesExpectFirst() -> [Int] {
    if self.isEmpty {
      return []
    }

    return .init(1..<self.count)
  }

  #if canImport(SwiftUI)
    private mutating func remove(atOffsets offsets: [Int]) {
      self.remove(atOffsets: IndexSet(offsets))
    }
  #else
    private mutating func remove(atOffsets offsets: [Int]) {
      // Sort indices in descending order to avoid index shifting issues
      let sortedIndices = offsets.sorted(by: >)
      for index in sortedIndices {
        guard index >= 0, index < count else { continue }
        remove(at: index)
      }
    }
  #endif

  /// Removes duplicate elements from the array based on a provided grouping function.
  /// - Parameter groupingBy: A closure that takes an element and returns a hashable value
  /// to group the elements by.
  /// - Parameter indiciesToRemove: A closure that takes an array of grouped elements and
  /// returns the indices of the elements to remove.
  /// Defaults to `indiciesExpectFirst`.
  /// - Parameter removeAtOffsets:
  /// A closure that takes the array and a list of indices to remove elements at.
  /// Defaults to `Self.remove(from:atOffsets:)`.
  public func removingDuplicates(
    groupingBy: @Sendable @escaping (Element) -> some Hashable,
    indiciesToRemove: @Sendable @escaping ([Element]) -> [Int] = indiciesExpectFirst,
    removeAtOffsets: @Sendable @escaping (inout Self, [Int]) -> Void = Self.remove(from:atOffsets:)
  ) -> Self {
    var other = self
    other.removeDuplicates(
      groupingBy: groupingBy,
      indiciesToRemove: indiciesToRemove,
      removeAtOffsets: removeAtOffsets
    )
    return other
  }

  /// Removes duplicate elements from the array based on a provided grouping function.
  /// - Parameter groupingBy: A closure that takes an element and returns a hashable value
  /// to group the elements by.
  /// - Parameter indiciesToRemove: A closure that takes an array of grouped elements and
  /// returns the indices of the elements to remove.
  /// Defaults to `indiciesExpectFirst`.
  /// - Parameter removeAtOffsets:
  /// A closure that takes the array and a list of indices to remove elements at.
  /// Defaults to `Self.remove(from:atOffsets:)`.
  public mutating func removeDuplicates(
    groupingBy: @Sendable @escaping (Element) -> some Hashable,
    indiciesToRemove: @Sendable @escaping ([Element]) -> [Int] = indiciesExpectFirst,
    removeAtOffsets: @Sendable @escaping (inout Self, [Int]) -> Void = Self.remove(from:atOffsets:)
  ) {
    let duplicateIndicies: [Int] = Dictionary(
      grouping: self.enumerated(),
      by: { groupingBy($0.element) }
    )
    .flatMap { pair -> [Int] in
      let elements = pair.value.map(\.element)
      let indicesToRemove = indiciesToRemove(elements)
      return indicesToRemove.map { index in
        pair.value[index].offset
      }
    }
    .sorted(by: >)  // Sort in descending order to avoid index shifting issues

    removeAtOffsets(&self, duplicateIndicies)
  }
}
