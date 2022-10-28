//
// VirtualizationSession.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelMachine
  import Foundation
  #if canImport(SwiftUI)
    import SwiftUI
  #endif
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

    internal init(machine: VZVirtualMachine, delegate: MachineSessionDelegate? = nil) {
      self.delegate = delegate
      self.machine = machine
      super.init()
      self.machine.delegate = self
    }

    weak var delegate: BushelMachine.MachineSessionDelegate?

    @MainActor let machine: VZVirtualMachine

    @MainActor
    func begin() async throws {
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

    #if canImport(SwiftUI)
      var view: AnyView {
        AnyView(VirtualizationMachineView(virtualMachine: machine))
      }
    #endif

    func virtualMachine(_: VZVirtualMachine, didStopWithError error: Error) {
      delegate?.session(self, didStopWithError: error)
    }

    func virtualMachine(
      _: VZVirtualMachine,
      networkDevice: VZNetworkDevice,
      attachmentWasDisconnectedWithError error: Error
    ) {
      delegate?.session(
        self,
        device: networkDevice,
        attachmentWasDisconnectedWithError: error
      )
    }

    func guestDidStop(_: VZVirtualMachine) {
      delegate?.sessionDidStop(self)
    }
  }

  extension VirtualizationSession {
    convenience init(fromConfigurationURL configurationURL: URL, basedOn specifications: MachineSpecification) throws {
      let configuration = try VZVirtualMachineConfiguration(
        contentsOfDirectory: configurationURL,
        basedOn: specifications
      )
      try configuration.validate()
      self.init(machine: VZVirtualMachine(configuration: configuration))
    }

    static func validate(fromConfigurationURL configurationURL: URL, basedOn specifications: MachineSpecification) throws {
      let configuration = try VZVirtualMachineConfiguration(
        contentsOfDirectory: configurationURL,
        basedOn: specifications
      )
      try configuration.validate()
    }
  }
#endif
