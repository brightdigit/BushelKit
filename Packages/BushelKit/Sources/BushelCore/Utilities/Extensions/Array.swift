//
//  Array.swift
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
