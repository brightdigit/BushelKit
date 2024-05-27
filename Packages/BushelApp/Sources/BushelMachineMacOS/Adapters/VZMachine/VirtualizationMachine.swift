//
// VirtualizationMachine.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelMachine
  import Foundation
  import Virtualization

  #warning("make actor?")
  internal final class VirtualizationMachine: NSObject, Machine {
    let url: URL
    var configuration: MachineConfiguration
    let machine: VZVirtualMachine
    let identifier: MachineIdentifier
    let hardwareModel: HardwareModel

    // swiftlint:disable:next implicitly_unwrapped_optional
    var observation: (any KVObservation)!
    var observers = [UUID: @Sendable @MainActor (MachineChange) -> Void]()

    var machineIdentifer: UInt64? {
      identifier.ecID
    }

    @MainActor
    internal init(
      url: URL,
      configuration: MachineConfiguration,
      machine: VZVirtualMachine,
      data: VirtualizationData
    ) {
      self.url = url
      self.configuration = configuration
      self.machine = machine
      self.hardwareModel = data.hardwareModel
      self.identifier = data.machineIdentifier

      super.init()

      self.machine.delegate = self
      self.observation = self.machine.addObserver(self, options: [.initial, .new, .old])

      guard url.startAccessingSecurityScopedResource() else {
        Self.logger.error("Couldn't start accessing resource at \(url)")
        assertionFailure("Couldn't start accessing resource at \(url)")
        return
      }
    }

    #warning("logging-note: let's log the else case of these guards")
    // swiftlint:disable:next block_based_kvo
    override func observeValue(
      forKeyPath keyPath: String?,
      of _: Any?,
      change: [NSKeyValueChangeKey: Any]?,
      context _: UnsafeMutableRawPointer?
    ) {
      guard let keyPath else {
        return
      }
      guard let propertyUpdate = MachineChange.PropertyChange(
        keyPath: keyPath,
        new: change?[.newKey],
        old: change?[.oldKey]
      ) else {
        return
      }

      notifyObservers(.property(propertyUpdate))
    }

    deinit {
      self.observers.removeAll()
      self.observation = nil

      url.stopAccessingSecurityScopedResource()
    }
  }
#endif
