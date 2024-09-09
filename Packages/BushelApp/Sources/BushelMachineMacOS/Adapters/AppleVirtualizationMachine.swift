//
// AppleVirtualizationMachine.swift
// Copyright (c) 2024 BrightDigit.
//

//
//  AppleVirtualizationMachine.swift
//  BushelApp
//
//  Created by Leo Dion on 7/30/24.
//

#if canImport(Virtualization) && canImport(SwiftUI)
  public import BushelCore

  public import Foundation

  public import BushelMachine

  public import Virtualization

  public import BushelLogging

  public import BushelScreenCore

  public import SwiftUI

  public actor AppleVirtualizationMachine: Machine, Loggable, Sessionable {
    var lastChange: MachineChange?
    @MainActor
    public func view(_ settings: Binding<ScreenSettings>) -> some View {
      VirtualizationScreenView(virtualMachine: self.vzMachine, settings: settings)
    }

    public nonisolated func beginSnapshot() throws -> BushelMachine.SnapshotPaths {
      guard url.startAccessingSecurityScopedResource() else {
        throw MachineError.accessDeniedError(nil, at: url)
      }
      return .init(machinePathURL: url)
    }

    public func finishedWithSnapshot(_ snapshot: BushelMachine.Snapshot, by difference: BushelMachine.SnapshotDifference) {
      Self.logger.debug("Finished with Snapshot operation \(difference.rawValue).")
      url.stopAccessingSecurityScopedResource()
      switch difference {
      case .append:
        self.updatedConfiguration = .init(original: self.updatedConfiguration) { snapshots in
          var newSnapshots = snapshots
          newSnapshots.append(snapshot)

          return newSnapshots
        }

      case .remove:
        let index = self.updatedConfiguration.snapshots.firstIndex { $0.id == snapshot.id }
        guard let index else {
          Self.logger.error("Unable to find snapshot with id: \(snapshot.id)")
          assertionFailure("Unable to find snapshot with id: \(snapshot.id)")
          return
        }
        self.updatedConfiguration = .init(original: self.updatedConfiguration) { snapshots in
          var newSnapshots = snapshots
          newSnapshots.remove(at: index)

          return newSnapshots
        }

      case .restored:
        break

      case .export:
        break
      }
    }

    public func finishedWithSyncronization(_ difference: BushelMachine.SnapshotSyncronizationDifference?) throws {
      if let difference {
        let indicies = self.updatedConfiguration.snapshots.enumerated().compactMap { index, snapshot in
          difference.snapshotIDs.contains(snapshot.id) ? nil : index
        }
        let indexSet = IndexSet(indicies)
        self.updatedConfiguration = .init(original: self.updatedConfiguration) { snapshots in
          var newSnapshots = snapshots
          newSnapshots.remove(atOffsets: indexSet)
          newSnapshots.append(contentsOf: difference.addedSnapshots)
          newSnapshots.removeDuplicates(groupingBy: { $0.id })
          newSnapshots.sort(by: { $0.createdAt < $1.createdAt })

          return newSnapshots
        }
        Self.logger.notice(
          "Updated configured snapshots: -\(indicies.count) +\(difference.addedSnapshots.count)"
        )
      }
      url.stopAccessingSecurityScopedResource()
    }

    public func updatedMetadata(forSnapshot snapshot: BushelMachine.Snapshot, atIndex index: Int) {
      self.updatedConfiguration = .init(original: self.updatedConfiguration) { snapshots in
        var newSnapshots = snapshots
        newSnapshots[index] = snapshot

        return newSnapshots
      }
    }

    public nonisolated func beginObservation(_ update: @escaping @Sendable (BushelMachine.MachineChange) -> Void) -> UUID {
      let id = UUID()
      Task {
        await self.observers.addObservation(update, withID: id)
        if let lastChange = await lastChange {
          update(lastChange)
        }
      }
      return id
    }

    public static var loggingCategory: BushelLogging.Category {
      .machine
    }

    public init(
      url: URL,
      machineIdentifer: UInt64,
      configuration: MachineConfiguration,
      vzMachine: @MainActor @Sendable @escaping () throws -> VZVirtualMachine
    ) async throws {
      self.url = url
      self.machineIdentifer = machineIdentifer
      self.initialConfiguration = configuration
      self.updatedConfiguration = configuration
      self.observer = try await MainActor.run {
        let vzMachine = try vzMachine()
        let observer = VZMachineObserver(observe: vzMachine, notifyObservers: self.notifyObservers(_:))
        self.vzMachine = vzMachine
        return observer
      }
    }

    public nonisolated func removeObservation(withID id: UUID) {
      Task {
        let didExist = await self.observers.removeObserver(withID: id)
        assert(didExist)
        Self.logger.error("Missing observer for \(id)")
      }
    }

    let url: URL

    @MainActor
    private var vzMachine: VZVirtualMachine!
    public let machineIdentifer: UInt64?
    private nonisolated(unsafe) var observer: VZMachineObserver!
    let observers = MachineObservationCollection()
    public let initialConfiguration: MachineConfiguration
    public var updatedConfiguration: BushelMachine.MachineConfiguration

    @Sendable
    public nonisolated func notifyObservers(_ update: MachineChange) {
      Task {
        await self.saveLastUpdate(update)
        await self.observers.notifyObservers(of: update)
      }
    }

    private func saveLastUpdate(_ update: MachineChange) {
      self.lastChange = update
    }

    public func start() async throws {
      try await Task { @MainActor in
        try await self.vzMachine.start()
      }.value
    }

    public func pause() async throws {
      try await Task { @MainActor in
        try await self.vzMachine.pause()
      }.value
    }

    public func stop() async throws {
      try await Task { @MainActor in
        try await self.vzMachine.stop()
      }.value
    }

    public func resume() async throws {
      try await Task { @MainActor in
        try await self.vzMachine.resume()
      }.value
    }

    public func requestStop() async throws {
      try await Task { @MainActor in
        try self.vzMachine.requestStop()
      }.value
    }
  }

#endif
