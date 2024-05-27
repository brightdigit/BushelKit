//
// MachineObjectComponents.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelDataCore
  import BushelMachine
  import BushelMachineData
  import Foundation
  import SwiftData

  internal struct MachineObjectComponents: Sendable {
    typealias Machine = (any BushelMachine.Machine)

    let bookmarkData: BookmarkData
    let machine: Machine
    let restoreImage: OperatingSystemVersionComponents?
    let existingEntry: MachineEntry?
    let configuration: MachineObjectConfiguration
    let label: MetadataLabel

    internal init(
      machine: Machine,
      restoreImage: OperatingSystemVersionComponents?,
      configuration: MachineObjectConfiguration,
      existingEntry: MachineEntry?,
      bookmarkData: BookmarkData,
      label: MetadataLabel
    ) {
      if restoreImage == nil {
        MachineObject.logger.warning(
          "Missing restore image with id: \(machine.configuration.restoreImageFile)"
        )
      }

      self.machine = machine
      self.restoreImage = restoreImage
      self.configuration = configuration
      self.existingEntry = existingEntry
      self.bookmarkData = bookmarkData
      self.label = label
    }

    init(
      configuration: MachineObjectConfiguration,
      bookmarkData: BookmarkData,
      existingEntry: MachineEntry?
    ) async throws {
      let newURL: URL
      do {
        newURL = try await bookmarkData.fetchURL(using: configuration.database)
      } catch {
        throw try MachineError.bookmarkError(error)
      }
      guard newURL.startAccessingSecurityScopedResource() else {
        throw MachineError.accessDeniedError(nil, at: newURL)
      }
      defer {
        newURL.stopAccessingSecurityScopedResource()
      }

      let machine: Machine
      do {
        machine = try await configuration.systemManager.machine(contentOf: newURL)
      } catch {
        throw MachineError.corruptedError(error, at: newURL)
      }

      let restoreImage: (any InstallerImage)?

      do {
        restoreImage = try await configuration.restoreImageDB.image(
          withID: machine.configuration.restoreImageFile.imageID,
          library: machine.configuration.restoreImageFile.libraryID,
          configuration.labelProvider
        )
      } catch {
        throw MachineError.fromDatabaseError(error)
      }

      let label = configuration.labelProvider(machine.configuration.vmSystemID, machine.configuration)

      self.init(
        machine: machine,
        restoreImage: restoreImage?.components,
        configuration: configuration,
        existingEntry: existingEntry,
        bookmarkData: bookmarkData,
        label: label
      )
    }

    init(
      configuration: MachineObjectConfiguration
    ) async throws {
      let bookmarkData: BookmarkData
      bookmarkData = try await BookmarkData.resolveURL(configuration.url, with: configuration.database)

      let bookmarkDataID = bookmarkData.bookmarkID
      var machinePredicate = FetchDescriptor<MachineEntry>(
        predicate: #Predicate { $0.bookmarkDataID == bookmarkDataID }
      )

      machinePredicate.fetchLimit = 1

      let item: MachineEntry?
      do {
        item = try await configuration.database.first(
          where: #Predicate { $0.bookmarkDataID == bookmarkDataID }
        )
      } catch {
        throw MachineError.fromDatabaseError(error)
      }
      try await self.init(
        configuration: configuration,
        bookmarkData: bookmarkData,
        existingEntry: item
      )

      do {
        try await bookmarkData.update(using: configuration.database)
      } catch {
        assertionFailure(error: error)
      }
    }
  }

#endif
