//
// Array.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

#if canImport(SwiftUI)
  import SwiftUI
#endif

extension Array {
  @Sendable
  public static func remove(from array: inout Self, atOffsets offsets: [Int]) {
    array.remove(atOffsets: offsets)
  }

  @Sendable
  public static func indiciesExpectFirst(_ array: Self) -> [Int] {
    array.indiciesExpectFirst()
  }

  private func indiciesExpectFirst() -> [Int] {
    if self.isEmpty {
      return []
    }

    return .init(1 ..< self.count)
  }

  #if canImport(SwiftUI)
    private mutating func remove(atOffsets offsets: [Int]) {
      self.remove(atOffsets: IndexSet(offsets))
    }
  #else

    private mutating func remove(atOffsets _: [Int]) {
      let sortedIndices = indices.sorted(by: >)
      for index in sortedIndices {
        assert(index >= 0 && index < self.count)
        guard index >= 0, index < self.count else {
          continue // Skip invalid indices
        }
        self.remove(at: index)
      }
    }
  #endif

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
      indiciesToRemove(
        pair.value.map(\.element)
      )
      .map { index in
        pair.value[index].offset
      }
    }
    removeAtOffsets(&self, duplicateIndicies)
  }
}
