//
// MachineObjectComponents.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelDataCore
  import BushelMachine
  import BushelMachineData
  import Foundation
  import SwiftData

  struct MachineObjectComponents {
    typealias Machine = (any BushelMachine.Machine)

    let bookmarkData: BookmarkData
    let machine: Machine
    let restoreImage: OperatingSystemInstalled?
    let existingEntry: MachineEntry?
    let configuration: MachineObjectConfiguration
    let label: MetadataLabel

    internal init(
      machine: Machine,
      restoreImage: OperatingSystemInstalled?,
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
        newURL = try bookmarkData.fetchURL(using: configuration.modelContext, withURL: configuration.url)
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
        restoreImage = try configuration.restoreImageDB.image(
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
        restoreImage: restoreImage,
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
      bookmarkData = try BookmarkData.resolveURL(configuration.url, with: configuration.modelContext)

      defer {
        do {
          try bookmarkData.update(using: configuration.modelContext)
        } catch {
          assertionFailure(error: error)
        }
      }

      let bookmarkDataID = bookmarkData.bookmarkID
      var machinePredicate = FetchDescriptor<MachineEntry>(
        predicate: #Predicate { $0.bookmarkDataID == bookmarkDataID }
      )

      machinePredicate.fetchLimit = 1

      let items: [MachineEntry]
      do {
        items = try configuration.modelContext.fetch(machinePredicate)
      } catch {
        throw MachineError.fromDatabaseError(error)
      }
      try await self.init(
        configuration: configuration,
        bookmarkData: bookmarkData,
        existingEntry: items.first
      )
    }
  }

#endif
