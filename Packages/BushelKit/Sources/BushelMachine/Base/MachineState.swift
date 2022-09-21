//
// MachineState.swift
// Copyright (c) 2022 BrightDigit.
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
}
