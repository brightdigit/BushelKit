//
//  Initialization.swift
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

@MainActor
public final class Initialization {
  /// A static instance of the `Initialization` class.
  public static let begin = Initialization()

  /// A flag indicating whether the initialization process has been completed.
  private var isCompleted = false

  /// Initializes a new instance of the `Initialization` class.
  private init() {}

  /// Executes the provided closure asynchronously on the main actor.
  ///
  /// - Parameter closure: The closure to be executed on the main actor.
  public nonisolated func callAsFunction(_ closure: @MainActor @Sendable @escaping () -> Void) {
    Task {
      await self.execute(closure)
    }
  }

  /// Executes the provided closure on the main actor,
  /// ensuring that the initialization process is completed only once.
  ///
  /// - Parameter closure: The closure to be executed on the main actor.
  internal func execute(_ closure: @MainActor @Sendable @escaping () -> Void) {
    guard !self.isCompleted else {
      return
    }
    self.isCompleted = true
    closure()
  }
}
