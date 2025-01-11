//
//  ByteCountFormatter.swift
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

/// Provides extensions to the `ByteCountFormatter` type.
extension ByteCountFormatter {
  /// A static `ByteCountFormatter` instance with the `memory` count style.
  public nonisolated(unsafe) static let memory: ByteCountFormatter = .init(countStyle: .memory)

  /// A static `ByteCountFormatter` instance with the `file` count style.
  public nonisolated(unsafe) static let file: ByteCountFormatter = .init(countStyle: .file)

  /// Initializes a `ByteCountFormatter` instance and applies the specified modifications.
  ///
  /// - Parameter modifications: A closure that modifies the `ByteCountFormatter` instance.
  public convenience init(_ modifications: @escaping (ByteCountFormatter) -> Void) {
    self.init()
    modifications(self)
  }

  /// Initializes a `ByteCountFormatter` instance with the specified count style.
  ///
  /// - Parameter countStyle: The count style to be used by the `ByteCountFormatter` instance.
  public convenience init(countStyle: CountStyle) {
    self.init {
      $0.countStyle = countStyle
    }
  }
}
