//
// VirtualizationSession.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import Foundation
import SwiftUI
import Virtualization

class VirtualizationSession: NSObject, MachineSession, VZVirtualMachineDelegate {
  @MainActor
  var state: BushelMachine.MachineState {
    .init(vzMachineState: machine.state)
  }

  @MainActor
  func stop() async throws {
    try await machine.stop()
  }

  @MainActor
  func pause() async throws {
    try await machine.pause()
  }

  @MainActor
  func resume() async throws {
    try await machine.resume()
  }

  @MainActor
  var allowedStateAction: StateAction {
    .init(machine: machine)
  }

  internal init(delegate: MachineSessionDelegate? = nil, machine: VZVirtualMachine) {
    self.delegate = delegate
    self.machine = machine
    super.init()
    self.machine.delegate = self
  }

  weak var delegate: BushelMachine.MachineSessionDelegate?

  @MainActor let machine: VZVirtualMachine

  @MainActor
  public func begin() async throws {
    try await withCheckedThrowingContinuation { continuation in

      machine.start { result in
        continuation.resume(with: result)
      }
    }
  }

  @MainActor
  func requestShutdown() throws {
    try machine.requestStop()
  }

  public var view: AnyView {
    AnyView(VirtualizationMachineView(virtualMachine: machine))
  }

  func virtualMachine(_: VZVirtualMachine, didStopWithError error: Error) {
    delegate?.session(self, didStopWithError: error)
  }

  func virtualMachine(_: VZVirtualMachine, networkDevice: VZNetworkDevice, attachmentWasDisconnectedWithError error: Error) {
    delegate?.session(self, device: networkDevice, attachmentWasDisconnectedWithError: error)
  }

  func guestDidStop(_: VZVirtualMachine) {
    delegate?.sessionDidStop(self)
  }
}

extension VirtualizationSession {
  convenience init(fromConfigurationURL configurationURL: URL) throws {
    let configuration = try VZVirtualMachineConfiguration(contentsOfDirectory: configurationURL)
    try configuration.validate()
    self.init(machine: VZVirtualMachine(configuration: configuration))
  }

  static func validate(fromConfigurationURL configurationURL: URL) throws {
    let configuration = try VZVirtualMachineConfiguration(contentsOfDirectory: configurationURL)
    try configuration.validate()
  }
}
