//
//  PropertyChange.swift
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

public protocol PropertyChange: PropertyChangeFromValue, Sendable {
  associatedtype ValueType: Sendable
  var values: PropertyValues<ValueType> { get }
  static var property: MachineProperty { get }
  init(values: PropertyValues<ValueType>)
}

public struct StatePropertyChange: PropertyChange {
  public let values: PropertyValues<MachineState>
  public nonisolated(unsafe) static let property: MachineProperty = .state
  public init(values: PropertyValues<MachineState>) {
    self.values = values
  }
}

public struct CanStartPropertyChange: PropertyChange {
  public let values: PropertyValues<Bool>
  public nonisolated(unsafe) static let property: MachineProperty = .canStart
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

public struct CanStopPropertyChange: PropertyChange {
  public let values: PropertyValues<Bool>
  public nonisolated(unsafe) static let property: MachineProperty = .canStop
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

public struct CanPausePropertyChange: PropertyChange {
  public let values: PropertyValues<Bool>
  public nonisolated(unsafe) static let property: MachineProperty = .canPause
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

public struct CanResumePropertyChange: PropertyChange {
  public let values: PropertyValues<Bool>
  public nonisolated(unsafe) static let property: MachineProperty = .canResume
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

public struct CanRequestStopPropertyChange: PropertyChange {
  public let values: PropertyValues<Bool>
  public nonisolated(unsafe) static let property: MachineProperty = .canRequestStop
  public init(values: PropertyValues<Bool>) {
    self.values = values
  }
}

extension PropertyChange {
  public func getValue<Value: Sendable>() -> Value? {
    let value = self.values.new as? Value
    // assert(value != nil)
    return value
  }
}
