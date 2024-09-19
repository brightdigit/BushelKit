//
// MachineEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && canImport(SwiftData)
  import class BushelDataCore.BookmarkData
  import BushelMachine
  import BushelMachineData
  import DataThespian
  import Foundation

  extension MachineEntry {
    static func basedOnComponents(
      _ components: MachineObjectComponents
    ) async throws -> ModelID<MachineEntry> {
      let updatedConfiguration = await components.machine.updatedConfiguration
      let database = components.configuration.database
      if let model = components.existingModel {
        do {
          return try await MachineEntry.synchronizeModel(
            model,
            with: components.machine,
            osInstalled: components.restoreImage,
            using: database
          )
        } catch {
          throw MachineError.fromDatabaseError(error)
        }
      } else {
        let url = components.configuration.url

        let bookmarkDataID = try await BookmarkData.withDatabase(database, fromURL: url) { $0.bookmarkID
        }

        let machineModel: ModelID = await database.insert {
          MachineEntry(
            bookmarkDataID: bookmarkDataID,
            machine: components.machine,
            updatedConfiguration: updatedConfiguration,
            osInstalled: components.restoreImage,
            restoreImageID: updatedConfiguration.restoreImageFile.imageID,
            name: components.configuration.url.deletingPathExtension().lastPathComponent,
            createdAt: Date(),
            lastOpenedAt: Date()
          )
        }
        return machineModel
      }
    }
  }
#endif
