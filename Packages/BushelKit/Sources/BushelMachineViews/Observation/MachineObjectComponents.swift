//
// MachineObjectComponents.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)

  import BushelCore
  import BushelDataCore
  import BushelMachine
  import Foundation
  import SwiftData

  struct MachineObjectComponents {
    typealias Machine = BushelMachine.Machine
    internal init(machine: Machine, restoreImage: OperatingSystemInstalled?) {
      if restoreImage == nil {
        MachineObject.logger.warning("Missing restore image with id: \(machine.configuration.restoreImageFile)")
      }

      self.machine = machine
      self.restoreImage = restoreImage
    }

    let machine: Machine
    let restoreImage: OperatingSystemInstalled?

    init(
      configuration: MachineObjectConfiguration,
      bookmarkData: BookmarkData
    ) throws {
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
        machine = try configuration.systemManager.machine(contentOf: newURL)
      } catch {
        throw MachineError.corruptedError(error, at: newURL)
      }

      let restoreImage: InstallerImage?

      do {
        restoreImage = try configuration.restoreImageDB.installImage(
          withID: machine.configuration.restoreImageFile.imageID,
          library: machine.configuration.restoreImageFile.libraryID,
          configuration.labelProvider
        )
      } catch {
        throw MachineError.fromDatabaseError(error)
      }

      self.init(machine: machine, restoreImage: restoreImage)
    }
  }

#endif
