//
//  MachineChange.swift
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

/// Represents a change to a machine.
public struct MachineChange: Sendable {
  /// Represents an event that can occur on a machine.
  public enum Event: Sendable, CustomStringConvertible {
    /// Represents a change to a property.
    case property(any PropertyChange)
    /// Represents the guest stopping.
    case guestDidStop
    /// Represents the machine stopping with an error.
    case stopWithError(any Error)
    /// Represents the network being detached with an error.
    case networkDetatchedWithError(any Error)

    /// A textual representation of the event.
    public var description: String {
      switch self {
      case .property:
        "property"
      case .guestDidStop:
        "guestDidStop"
      case .stopWithError:
        "stopWithError"
      case .networkDetatchedWithError:
        "networkDetatchedWithError"
      }
    }
  }

  /// The event that occurred.
  public let event: Event
  /// The properties of the machine.
  public let properties: MachineProperties?

  /// Creates a new `MachineChange` instance.
  ///
  /// - Parameters:
  ///   - event: The event that occurred.
  ///   - properties: The properties of the machine.
  public init(event: MachineChange.Event, properties: MachineProperties?) {
    self.event = event
    self.properties = properties
  }
}
