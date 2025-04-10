//
//  MachineState.swift
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

public enum MachineState: Int, Sendable {
  /// Initial state before the virtual machine is started.
  case stopped = 0

  /// Running virtual machine.
  case running = 1

  /// A started virtual machine is paused.
  /// This state can only be transitioned from VZVirtualMachineStatePausing.
  case paused = 2

  /// The virtual machine has encountered an internal error.
  case error = 3

  /// The virtual machine is configuring the hardware and starting.
  case starting = 4

  /// The virtual machine is being paused.
  /// This is the intermediate state between VZVirtualMachineStateRunning and VZVirtualMachineStatePaused.
  case pausing = 5

  /// The virtual machine is being resumed.
  /// This is the intermediate state between VZVirtualMachineStatePaused and VZVirtualMachineStateRunning.
  case resuming = 6

  /// The virtual machine is being stopped.
  /// This is the intermediate state between VZVirtualMachineStateRunning and VZVirtualMachineStateStop.
  case stopping = 7

  /// The virtual machine is being saved.
  /// This is the intermediate state between VZVirtualMachineStatePaused and VZVirtualMachineStatePaused.
  case saving = 8

  /// The virtual machine is being restored.
  /// This is the intermediate state between VZVirtualMachineStateStopped and
  /// either VZVirtualMachineStatePaused on success or VZVirtualMachineStateStopped on failure.
  case restoring = 9
}

extension MachineState {
  public var sfSystemName: String {
    switch self {
    case .stopped:
      "stop.fill"
    case .running:
      "play.fill"
    case .paused:
      "pause.fill"
    case .error:
      "exclamationmark.triangle.fill"
    case .starting:
      "play"
    case .pausing:
      "pause"
    case .resuming:
      "play"
    case .stopping:
      "stop"
    case .saving:
      "camera"
    case .restoring:
      "camera.badge.clock"
    }
  }
}
