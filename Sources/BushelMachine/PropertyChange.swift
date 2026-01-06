//
//  PropertyChange.swift
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

/// A struct representing a change in the machine state property.
public struct StatePropertyChange: PropertyChange {
  /// The type of the property value.
  public typealias ValueType = MachineState

  /// The associated machine property for this change.
  nonisolated(unsafe) public static let property: MachineProperty = .state

  /// The property values associated with this change.
  public let values: PropertyValues<MachineState>

  /// Initializes a new `StatePropertyChange` instance.
  /// - Parameter values: The property values associated with this change.
  public init(values: PropertyValues<MachineState>) {
    self.values = values
  }
}

/// A struct representing a change in the can start property.
public struct CanStartPropertyChange: PropertyChange {
  /// The associated machine property for this change.
  nonisolated(unsafe) public static let property: MachineProperty = .canStart

  /// The property values associated with this change.
  public let values: PropertyValues<Bool>

  /// Initializes a new `CanStartPropertyChange` instance.
  /// - Parameter values: The property values associated with this change.
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

/// A struct representing a change in the can stop property.
public struct CanStopPropertyChange: PropertyChange {
  /// The associated machine property for this change.
  nonisolated(unsafe) public static let property: MachineProperty = .canStop

  /// The property values associated with this change.
  public let values: PropertyValues<Bool>

  /// Initializes a new `CanStopPropertyChange` instance.
  /// - Parameter values: The property values associated with this change.
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

/// A struct representing a change in the can pause property.
public struct CanPausePropertyChange: PropertyChange {
  /// The associated machine property for this change.
  nonisolated(unsafe) public static let property: MachineProperty = .canPause

  /// The property values associated with this change.
  public let values: PropertyValues<Bool>

  /// Initializes a new `CanPausePropertyChange` instance.
  /// - Parameter values: The property values associated with this change.
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

/// A struct representing a change in the can resume property.
public struct CanResumePropertyChange: PropertyChange {
  /// The associated machine property for this change.
  nonisolated(unsafe) public static let property: MachineProperty = .canResume

  /// The property values associated with this change.
  public let values: PropertyValues<Bool>

  /// Initializes a new `CanResumePropertyChange` instance.
  /// - Parameter values: The property values associated with this change.
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

/// A struct representing a change in the can request stop property.
public struct CanRequestStopPropertyChange: PropertyChange {
  /// The associated machine property for this change.
  nonisolated(unsafe) public static let property: MachineProperty = .canRequestStop

  /// The property values associated with this change.
  public let values: PropertyValues<Bool>

  /// Initializes a new `CanRequestStopPropertyChange` instance.
  /// - Parameter values: The property values associated with this change.
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

/// A protocol representing a property change in a machine.
public protocol PropertyChange: PropertyChangeFromValue, Sendable {
  /// The type of the property value.
  associatedtype ValueType: Sendable = Bool

  /// The associated machine property for this change.
  static var property: MachineProperty { get }

  /// The property values associated with this change.
  var values: PropertyValues<ValueType> { get }

  /// Initializes a new instance of the property change.
  /// - Parameter values: The property values associated with this change.
  init(values: PropertyValues<ValueType>)
}

extension PropertyChange {
  /// Gets the value of the property change.
  /// - Returns: The value of the property change,
  /// or `nil` if the value cannot be cast to the specified type.
  public func getValue<Value: Sendable>() -> Value? {
    let value = self.values.new as? Value
    return value
  }
}
