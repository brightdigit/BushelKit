//
//  AsyncReducer.swift
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

/// An actor that asynchronously reduces an `AsyncSequence` to an array of its elements.
public actor AsyncReducer<
  AsyncSequenceType: AsyncSequence & Sendable
> where AsyncSequenceType.Element: Sendable {
  /// The underlying `AsyncSequence` to be reduced.
  private let sequence: AsyncSequenceType
  /// The cached elements of the reduced sequence, if available.
  private var currentElements: [AsyncSequenceType.Element]?

  /// The elements of the reduced `AsyncSequence`.
  public var elements: [AsyncSequenceType.Element] {
    get async throws {
      if let currentElements {
        return currentElements
      }
      return try await self.reduce()
    }
  }

  /// Initializes the `AsyncReducer` with the given `AsyncSequence`.
  /// - Parameter sequence: The `AsyncSequence` to be reduced.
  public init(sequence: AsyncSequenceType) {
    self.sequence = sequence
  }

  /// Reduces the `AsyncSequence` to an array of its elements.
  /// - Returns: An array of the elements in the `AsyncSequence`.
  private func reduce() async throws -> [AsyncSequenceType.Element] {
    var elements = [AsyncSequenceType.Element]()
    for try await element in self.sequence {
      elements.append(element)
    }
    self.currentElements = elements
    return elements
  }
}
