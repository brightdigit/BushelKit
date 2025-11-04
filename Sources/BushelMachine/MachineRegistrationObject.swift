//
//  MachineRegistrationObject.swift
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

/// Object which registers the machine into the inventory.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
public struct MachineRegistrationObject: Sendable {
  private let machine: any Machine
  public init(machine: any Machine) {
    self.machine = machine
  }

  /// Adds the machine to the inventory.
  /// - Parameters:
  ///   - inventory: ``MachineInventory`` to add the machine to.
  ///   - id: The id to use.
  /// - Returns: The actual ``Machine``
  public func register(_ inventory: MachineInventory, _ id: UUID) -> any Machine {
    inventory.registerMachine(machine, withID: id)
    return machine
  }
}
