//
//  MachineSystemManaging.swift
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
public import Foundation

/// A collection of machine systems for managing virtual machines
public protocol MachineSystemManaging: Sendable {
  /// Resolve the ``MachineSystem`` based on the ``VMSystemID``
  /// - Parameter id: id of the system to resolve.
  /// - Returns: The resulting ``MachineSystem``
  func resolve(_ id: VMSystemID) -> any MachineSystem
}

extension MachineSystemManaging where Self: Loggable {
  public static var loggingCategory: BushelLogging.Category {
    .library
  }
}

extension MachineSystemManaging {
  /// Resolves the ``MachineSystem`` and ``Machine`` based on the bundle at the URL.
  /// - Parameter url: Machine bundle URL.
  /// - Returns: The resolved ``Machine``
  public func machine(contentOf url: URL) async throws -> any Machine {
    let configuration: MachineConfiguration
    configuration = try MachineConfiguration(contentsOf: url)
    let system = self.resolve(configuration.vmSystemID)
    return try await system.machine(at: url, withConfiguration: configuration)
  }
}
