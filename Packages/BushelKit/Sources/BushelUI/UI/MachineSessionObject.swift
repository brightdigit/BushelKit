//
// MachineSessionObject.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine
import SwiftUI
import Virtualization

#warning("Remove `import Virtualization`")

class MachineSessionObject: NSObject, ObservableObject, VZVirtualMachineDelegate {
  @Published var session: MachineSession? {
    didSet {
      if let vm = session as? VZVirtualMachine {
        vm.delegate = self
      }
    }
  }

  func virtualMachine(_: VZVirtualMachine, didStopWithError error: Error) {
    dump(error)
  }

  func virtualMachine(_: VZVirtualMachine, networkDevice _: VZNetworkDevice, attachmentWasDisconnectedWithError error: Error) {
    dump(error)
  }

  func guestDidStop(_: VZVirtualMachine) {}
}
