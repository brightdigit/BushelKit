//
// MachineSessionObject.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/10/22.
//

import BushelMachine
import SwiftUI

class MachineSessionObject: NSObject, ObservableObject, MachineSessionDelegate {
  func sessionDidStop(_: BushelMachine.MachineSession) {}

  func session(_: BushelMachine.MachineSession, didStopWithError _: Error) {}

  func session(_: BushelMachine.MachineSession, device _: BushelMachine.MachineNetworkDevice, attachmentWasDisconnectedWithError _: Error) {}

  @Published var session: MachineSession? { didSet {
    if var session = session {
      session.delegate = self
    }
  }
  }
}
