//
// VZMachineObserver.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import Virtualization

  internal final class VZMachineObserver:
    NSObject, VZVirtualMachineDelegate, Sendable, Loggable {
    static var loggingCategory: BushelLogging.Category {
      .machine
    }

    // private nonisolated(unsafe) var observation: (any KVObservation)!
    private let propertyObservations = ObservationCollection()
    let notifyObservers: @Sendable (MachineChange) -> Void

    @MainActor
    init(observe machine: VZVirtualMachine, notifyObservers: @escaping @Sendable (MachineChange) -> Void) {
      // self.machine = machine
      self.notifyObservers = notifyObservers
      super.init()
      machine.delegate = self

      self.addObservation(forMachine: machine, with: .state())
      self.addObservation(forMachine: machine, with: .canStop())
      self.addObservation(forMachine: machine, with: .canPause())
      self.addObservation(forMachine: machine, with: .canStart())
      self.addObservation(forMachine: machine, with: .canResume())
      self.addObservation(forMachine: machine, with: .canRequestStop())
    }

    func addObservation(
      forMachine machine: VZVirtualMachine,
      with observable: PropertyChangeObserving<some PropertyChange, some Any>
    ) {
      let observation = self.observeMachine(machine, with: observable)
      Task {
        await self.propertyObservations.append(observation, withID: .init())
      }
    }

    func observeMachine<
      PropertyChangeType: PropertyChange
    >(
      _ machine: VZVirtualMachine,
      with observable: PropertyChangeObserving<PropertyChangeType, some Any>
    ) -> NSKeyValueObservation {
      self.observeMachine(
        machine,
        for: observable.keyPath,
        as: PropertyChangeType.self,
        by: observable.conversion
      )
    }

    func observeMachine<
      Value,
      PropertyChangeType: PropertyChange
    >(
      _ machine: VZVirtualMachine,
      for keyPath: KeyPath<VZVirtualMachine, Value>,
      as type: PropertyChangeType.Type
    ) -> NSKeyValueObservation where PropertyChangeType.ValueType == Value {
      self.observeMachine(machine, for: keyPath, as: type, by: { $0 })
    }

    func observeMachine<
      Value,
      PropertyChangeType: PropertyChange
    >(
      _ machine: VZVirtualMachine,
      for keyPath: KeyPath<VZVirtualMachine, Value>,
      as type: PropertyChangeType.Type,
      by convert: @escaping @Sendable (Value) -> PropertyChangeType.ValueType?
    ) -> NSKeyValueObservation {
      machine.observe(keyPath, options: [.initial, .old, .new]) { machine, change in
        let observedChange = KeyValueObservedChange(change: change, convert)
        let property = type.init(changes: observedChange)
        self.machine(machine, didChangeProperty: property)
      }
    }

    func machine(_ machine: VZVirtualMachine, didChangeProperty propertyChange: any PropertyChange) {
      notifyObservers(.init(event: .property(propertyChange), properties: .init(machine: machine)))
    }

    func guestDidStop(_ machine: VZVirtualMachine) {
      notifyObservers(.init(event: .guestDidStop, properties: .init(machine: machine)))
    }

    /// Invoked when a virtual machine is stopped due to an error.
    /// - Parameters:
    ///   - virtualMachine The virtual machine invoking the delegate method.
    ///   - error The error
    func virtualMachine(_ machine: VZVirtualMachine, didStopWithError error: any Error) {
      notifyObservers(.init(event: .stopWithError(error), properties: .init(machine: machine)))
    }

    /// Invoked when a virtual machine's network attachment has been disconnected.
    ///
    ///  This method is invoked every time that the network interface fails to start,
    ///  resulting in the network attachment being disconnected. This can happen
    ///  in many situations such as initial boot, device reset, reboot, etc.
    ///  Therefore, this method may be invoked several times during a virtual machine's life cycle.
    ///  The VZNetworkDevice.attachment property will be nil after the method is invoked.
    ///
    /// - Parameters:
    ///   - _: The virtual machine invoking the delegate method.
    ///   - _: The virtual machine invoking the delegate method.
    ///   - error: The error.
    func virtualMachine(
      _ machine: VZVirtualMachine,
      networkDevice _: VZNetworkDevice,
      attachmentWasDisconnectedWithError error: any Error
    ) {
      notifyObservers(.init(event: .networkDetatchedWithError(error), properties: .init(machine: machine)))
    }

    deinit {
      self.propertyObservations.clear()
    }
  }
#endif
