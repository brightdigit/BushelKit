//
// MachineState.swift
// Copyright (c) 2023 BrightDigit.
//

// swiftlint:disable line_length

import Foundation
public enum MachineState: Int {
  /** Initial state before the virtual machine is started. */
  case stopped = 0

  /** Running virtual machine. */
  case running = 1

  /** A started virtual machine is paused. This state can only be transitioned from VZVirtualMachineStatePausing. */
  case paused = 2

  /** The virtual machine has encountered an internal error. */
  case error = 3

  /** The virtual machine is configuring the hardware and starting. */
  case starting = 4

  /** The virtual machine is being paused. This is the intermediate state between VZVirtualMachineStateRunning and VZVirtualMachineStatePaused. */
  case pausing = 5

  /** The virtual machine is being resumed. This is the intermediate state between VZVirtualMachineStatePaused and VZVirtualMachineStateRunning. */
  case resuming = 6

  /** The virtual machine is being stopped. This is the intermediate state between VZVirtualMachineStateRunning and VZVirtualMachineStateStop. */
  case stopping = 7

  /** The virtual machine is being saved. This is the intermediate state between VZVirtualMachineStatePaused and VZVirtualMachineStatePaused. */
  case saving = 8

  /** The virtual machine is being restored. This is the intermediate state between VZVirtualMachineStateStopped and either VZVirtualMachineStatePaused on success or VZVirtualMachineStateStopped on failure. */
  case restoring = 9
}

public extension MachineState {
  var sfSystemName: String {
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
