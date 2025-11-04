//
//  MachineSystemManager.swift
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

public import BushelFoundation
public import BushelLogging
internal import Foundation

/// Implementation of a ``MachineSystemManaging``
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public final class MachineSystemManager: MachineSystemManaging, Loggable {
  private let implementations: [VMSystemID: any MachineSystem]

  /// Creates a ``MachineSystemManager`` based on the list of implementations.
  /// - Parameter implementations: Array of ``MachineSystem``
  public init(_ implementations: [any MachineSystem]) {
    self.implementations = .init(
      uniqueKeysWithValues: implementations.map {
        ($0.id, $0)
      }
    )
  }

  /// Resolve the ``MachineSystem`` based on the ``VMSystemID``.
  /// - Parameter id: The ID of the system to resolve.
  /// - Returns: The resulting ``MachineSystem``
  public func resolve(_ id: VMSystemID) -> any MachineSystem {
    guard let implementation = implementations[id] else {
      Self.logger.critical("Unknown system: \(id.rawValue)")
      preconditionFailure("Unknown system: \(id.rawValue)")
    }

    return implementation
  }
}
