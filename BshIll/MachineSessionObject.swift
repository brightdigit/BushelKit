//
//  MachineSessionView.swift
//  BshIll
//
//  Created by Leo Dion on 7/18/22.
//

import SwiftUI
import Virtualization


class MachineSessionObject : NSObject, ObservableObject, VZVirtualMachineDelegate {
  @Published var session : MachineSession? {
    didSet {
      if let vm = self.session as? VZVirtualMachine {
        vm.delegate = self
      }
    }
  }
  
  func virtualMachine(_ virtualMachine: VZVirtualMachine, didStopWithError error: Error) {
    dump(error)
  }
  
  func virtualMachine(_ virtualMachine: VZVirtualMachine, networkDevice: VZNetworkDevice, attachmentWasDisconnectedWithError error: Error) {
    dump(error)
  }
  
  func guestDidStop(_ virtualMachine: VZVirtualMachine) {
    
  }
}
