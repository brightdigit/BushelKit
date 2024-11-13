//
//  Dictionary.swift
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

extension Dictionary {
  /// Initializes a new dictionary from a sequence of values, using a closure to generate unique keys.
  ///
  /// - Parameters:
  ///   - values: A sequence of values to be used to initialize the dictionary.
  ///   - key: A closure that takes a value and returns a key for that value.
  /// - Returns: A new dictionary initialized with the unique keys and their corresponding values.
  @inlinable public init<S>(uniqueValues values: S, keyBy key: @escaping (Value) -> Key)
  where S: Sequence, S.Element == Value {
    let uniqueKeysWithValues: [(Key, Value)] = values.map { (key($0), $0) }
    self.init(uniqueKeysWithValues: uniqueKeysWithValues)
  }
}
