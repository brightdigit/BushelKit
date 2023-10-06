//
// MachineEntry.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(SwiftData)
  import BushelMachine
  import BushelMachineData
  import Foundation

  extension MachineEntry {
    #warning("Remove @MainActor")
    @MainActor
    static func basedOnComponents(_ components: MachineObjectComponents) throws -> MachineEntry {
      if let item = components.existingEntry {
        do {
          try item.synchronizeWith(
            components.machine,
            osInstalled: components.restoreImage,
            using: components.configuration.modelContext
          )
        } catch {
          throw MachineError.fromDatabaseError(error)
        }
        return item
      } else {
        do {
          return try MachineEntry(
            bookmarkData: components.bookmarkData,
            machine: components.machine,
            osInstalled: components.restoreImage,
            restoreImageID: components.machine.configuration.restoreImageFile.imageID,
            name: components.configuration.url.deletingPathExtension().lastPathComponent,
            createdAt: Date(),
            lastOpenedAt: Date(),
            withContext: components.configuration.modelContext
          )
        } catch {
          throw MachineError.fromDatabaseError(error)
        }
      }
    }
  }
#endif
