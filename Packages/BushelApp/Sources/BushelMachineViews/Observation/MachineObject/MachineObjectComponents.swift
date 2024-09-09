//
// MachineObjectComponents.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelDataCore
  import BushelMachine
  import BushelMachineData
  import DataThespian
  import Foundation
  import SwiftData

  internal struct MachineObjectComponents: Sendable {
    typealias Machine = (any BushelMachine.Machine)

    let machine: Machine
    let restoreImage: OperatingSystemVersionComponents?
    let existingModel: ModelID<MachineEntry>?
    let configuration: MachineObjectConfiguration
    let label: MetadataLabel

    internal init(
      machine: Machine,
      restoreImage: OperatingSystemVersionComponents?,
      configuration: MachineObjectConfiguration,
      existingModel: ModelID<MachineEntry>?,
      label: MetadataLabel
    ) {
      if restoreImage == nil {
        MachineObject.logger.warning(
          "Missing restore image with id: \(machine.initialConfiguration.restoreImageFile)"
        )
      }

      self.machine = machine
      self.restoreImage = restoreImage
      self.configuration = configuration
      self.existingModel = existingModel
      self.label = label
    }

    init(
      configuration: MachineObjectConfiguration,
      existingModel: ModelID<MachineEntry>
    ) async throws {
      let bookmarkDataID = try await configuration.database.with(existingModel) {
        $0.bookmarkDataID
      }
      let newURL = try await configuration.database.first(#Predicate<BookmarkData> { $0.bookmarkID == bookmarkDataID }) {
        try $0?.fetchURL()
      }
      guard let newURL else {
        throw MachineError.bookmarkError(.notFound(.id(bookmarkDataID)))
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
          withID: machine.updatedConfiguration.restoreImageFile.imageID,
          library: machine.updatedConfiguration.restoreImageFile.libraryID,
          configuration.labelProvider
        )
      } catch {
        throw MachineError.fromDatabaseError(error)
      }

      let label = await configuration.labelProvider(machine.updatedConfiguration.vmSystemID, machine.updatedConfiguration)

      self.init(
        machine: machine,
        restoreImage: restoreImage?.components,
        configuration: configuration,
        existingModel: existingModel,
        label: label
      )
    }

    init(
      configuration: MachineObjectConfiguration
    ) async throws {
      let bookmarkModel = try await BookmarkData.withDatabase(configuration.database, fromURL: configuration.url)
      guard let bookmarkModel else {
        throw MachineError.bookmarkError(.notFound(.url(configuration.url)))
      }
      let bookmarkDataID = try await configuration.database.with(bookmarkModel) {
        $0.update()
        return $0.bookmarkID
      }

      let model: ModelID<MachineEntry>?
      do {
        model = try await configuration.database.first(#Predicate { $0.bookmarkDataID == bookmarkDataID })
      } catch {
        throw MachineError.fromDatabaseError(error)
      }

      guard let model else {
        throw MachineError.notFound(bookmarkID: bookmarkDataID)
      }
      try await self.init(
        configuration: configuration,
        existingModel: model
      )
    }
  }

#endif
