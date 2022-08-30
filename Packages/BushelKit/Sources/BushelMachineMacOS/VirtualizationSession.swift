//
// VirtualizationSession.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import Foundation
import SwiftUI
import Virtualization

class VirtualizationSession: NSObject, MachineSession, VZVirtualMachineDelegate {
  internal init(delegate: MachineSessionDelegate? = nil, machine: VZVirtualMachine) {
    self.delegate = delegate
    self.machine = machine
    super.init()
    self.machine.delegate = self
  }

  weak var delegate: BushelMachine.MachineSessionDelegate?

  let machine: VZVirtualMachine
  @MainActor
  public func begin() async throws {
    try await withCheckedThrowingContinuation { continuation in

      machine.start { result in
        continuation.resume(with: result)
      }
    }
  }

  public var view: AnyView {
    AnyView(VirtualizationMachineView(virtualMachine: machine))
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
