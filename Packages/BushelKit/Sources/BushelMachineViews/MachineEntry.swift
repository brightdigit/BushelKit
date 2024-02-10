//
// MachineEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && canImport(SwiftData)
  import BushelMachine
  import BushelMachineData
  import Foundation

  extension MachineEntry {
    static func basedOnComponents(_ components: MachineObjectComponents) async throws -> MachineEntry {
      if let item = components.existingEntry {
        do {
          try await item.synchronizeWith(
            components.machine,
            osInstalled: components.restoreImage,
            using: components.configuration.database
          )
        } catch {
          throw MachineError.fromDatabaseError(error)
        }
        return item
      } else {
        do {
          return try await MachineEntry(
            bookmarkData: components.bookmarkData,
            machine: components.machine,
            osInstalled: components.restoreImage,
            restoreImageID: components.machine.configuration.restoreImageFile.imageID,
            name: components.configuration.url.deletingPathExtension().lastPathComponent,
            createdAt: Date(),
            lastOpenedAt: Date(),
            withDatabase: components.configuration.database
          )
        } catch {
          throw MachineError.fromDatabaseError(error)
        }
      }
    }
  }
#endif
