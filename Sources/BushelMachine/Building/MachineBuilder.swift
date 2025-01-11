//
//  MachineBuilder.swift
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

/// A protocol that defines the behavior of a machine builder.
public protocol MachineBuilder: Sendable {
  /// The URL of the machine.
  var url: URL { get }

  /// Observes the progress of the machine building process.
  /// - Parameter onUpdate: A closure that is called with the current progress
  /// as a value between 0.0 and 1.0.
  /// - Returns: A unique identifier for the observer.
  func observePercentCompleted(_ onUpdate: @escaping @Sendable (Double) -> Void) -> UUID

  /// Removes an observer from the machine builder.
  /// - Parameter id: The unique identifier of the observer to remove.
  /// - Returns: `true` if the observer was successfully removed, `false` otherwise.
  @discardableResult
  func removeObserver(_ id: UUID) async -> Bool

  /// Builds the machine.
  /// - Throws: An error that may occur during the build process.
  func build() async throws
}

extension MachineBuilder {
  /// Removes an observer from the machine builder.
  /// - Parameter observer: The observer to remove.
  public func removeObserver(_ observer: any MachineBuilderObserver) {
    Task {
      if let id = await observer.getID() {
        await self.removeObserver(id)
      }
    }
  }
}
