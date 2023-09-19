//
// VZMachine.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelCore
  import BushelLogging
  import BushelMachine
  import BushelMacOSCore
  import Foundation
  import SwiftUI
  import Virtualization

  class VZMachine: NSObject, Machine, VZVirtualMachineDelegate, LoggerCategorized {
    static var loggingCategory: BushelLogging.Loggers.Category {
      .machine
    }

    let url: URL
    let configuration: MachineConfiguration
    let machine: VZVirtualMachine
    // swiftlint:disable:next implicitly_unwrapped_optional
    var observation: KVObservation!
    var observers = [UUID: @MainActor (MachineChange) -> Void]()

    var state: BushelMachine.MachineState {
      // swiftlint:disable:next force_unwrapping
      .init(rawValue: machine.state.rawValue)!
    }

    @MainActor
    var canStart: Bool {
      self.machine.canStart
    }

    @MainActor
    var canStop: Bool {
      self.machine.canStop
    }

    @MainActor
    var canPause: Bool {
      self.machine.canPause
    }

    @MainActor
    var canResume: Bool {
      self.machine.canResume
    }

    @MainActor
    var canRequestStop: Bool {
      self.machine.canRequestStop
    }

    internal init(url: URL, configuration: MachineConfiguration, machine: VZVirtualMachine) {
      self.url = url
      self.configuration = configuration
      self.machine = machine

      super.init()

      self.machine.delegate = self
      self.observation = self.machine.addObserver(self, options: [.initial, .new, .old])

      guard url.startAccessingSecurityScopedResource() else {
        Self.logger.error("Couldn't start accessing resource at \(url)")
        assertionFailure("Couldn't start accessing resource at \(url)")
        return
      }
    }

    @MainActor
    func start() async throws {
      try await machine.start()
    }

    @MainActor
    func pause() async throws {
      try await machine.pause()
    }

    @MainActor
    func stop() async throws {
      try await machine.stop()
    }

    @MainActor
    func resume() async throws {
      try await machine.resume()
    }

    @MainActor
    func restoreMachineStateFrom(url saveFileURL: URL) async throws {
      try await self.machine.restoreMachineStateFrom(url: saveFileURL)
    }

    @MainActor
    func saveMachineStateTo(url saveFileURL: URL) async throws {
      try await self.machine.saveMachineStateTo(url: saveFileURL)
    }

    func requestStop() async throws {
      try await MainActor.run {
        try self.machine.requestStop()
      }
    }

    private func notifyObservers(_ event: MachineChange.Event) {
      let update = MachineChange(source: self, event: event)
      for value in observers.values {
        Task { @MainActor in
          value(update)
        }
      }
    }

    @discardableResult
    func removeObservation(withID id: UUID) -> Bool {
      self.observers.removeValue(forKey: id) != nil
    }

    func beginObservation(_ update: @escaping @MainActor (MachineChange) -> Void) -> UUID {
      let id = UUID()
      Self.logger.debug("Begin observations: \(id)")
      self.observers[id] = update
      return id
    }

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

    func guestDidStop(_: VZVirtualMachine) {
      notifyObservers(.guestDidStop)
    }

    /// Invoked when a virtual machine is stopped due to an error.
    /// - Parameters:
    ///   - virtualMachine The virtual machine invoking the delegate method.
    ///   - error The error
    func virtualMachine(_: VZVirtualMachine, didStopWithError error: Error) {
      notifyObservers(.stopWithError(error))
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
      _: VZVirtualMachine,
      networkDevice _: VZNetworkDevice,
      attachmentWasDisconnectedWithError error: Error
    ) {
      notifyObservers(.networkDetatchedWithError(error))
    }

    deinit {
      self.observers.removeAll()
      self.observation = nil

      url.stopAccessingSecurityScopedResource()
    }
  }

#endif
