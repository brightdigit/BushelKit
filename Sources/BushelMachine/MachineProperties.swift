//
//  MachineProperties.swift
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

public struct MachineProperties: Sendable {
  public let state: MachineState

  /// Return YES if the machine is in a state that can be started.
  ///
  /// - SeeAlso: ``start()``
  /// - SeeAlso: ``state``
  public let canStart: Bool

  /// Return YES if the machine is in a state that can be stopped.
  ///
  /// - SeeAlso: ``stop()``
  /// - SeeAlso: ``state``
  public let canStop: Bool

  /// Return YES if the machine is in a state that can be paused.
  ///
  /// - SeeAlso: ``pause()``
  /// - SeeAlso: ``state``
  public let canPause: Bool

  /// Return YES if the machine is in a state that can be resumed.
  ///
  /// - SeeAlso: ``resume()``
  /// - SeeAlso: ``state``
  public let canResume: Bool

  /// Returns whether the machine is in a state where the guest can be asked to stop.
  ///
  /// - SeeAlso: ``requestStop()``
  /// - SeeAlso: ``state``
  public let canRequestStop: Bool

  public init(
    state: MachineState,
    canStart: Bool,
    canStop: Bool,
    canPause: Bool,
    canResume: Bool,
    canRequestStop: Bool
  ) {
    self.state = state
    self.canStart = canStart
    self.canStop = canStop
    self.canPause = canPause
    self.canResume = canResume
    self.canRequestStop = canRequestStop
  }
}

extension MachineProperties {
  internal static let initial: Self = .init(
    state: .stopped,
    canStart: false,
    canStop: false,
    canPause: false,
    canResume: false,
    canRequestStop: false
  )
  private init(original: MachineProperties, propertyChange: any PropertyChange) {
    let type = type(of: propertyChange)

    var state: MachineState = original.state
    var canStart: Bool = original.canStart
    var canStop: Bool = original.canStop
    var canPause: Bool = original.canPause
    var canResume = original.canResume
    var canRequestStop = original.canRequestStop

    switch type.property {
    case .state:
      state = propertyChange.getValue() ?? state
    case .canStart:
      canStart = propertyChange.getValue() ?? canStart
    case .canStop:
      canStop = propertyChange.getValue() ?? canStop
    case .canPause:
      canPause = propertyChange.getValue() ?? canPause
    case .canResume:
      canResume = propertyChange.getValue() ?? canResume
    case .canRequestStop:
      canRequestStop = propertyChange.getValue() ?? canRequestStop
    }
    self.init(
      state: state,
      canStart: canStart,
      canStop: canStop,
      canPause: canPause,
      canResume: canResume,
      canRequestStop: canRequestStop
    )
  }
  internal func updateProperty(_ property: any PropertyChange) -> MachineProperties {
    .init(original: self, propertyChange: property)
  }
}
