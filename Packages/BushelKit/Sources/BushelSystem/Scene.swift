//
// Scene.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelHub
  import BushelHubEnvironment
  import BushelLibrary
  import BushelLibraryEnvironment
  import BushelMachine
  import BushelMachineEnvironment
  import BushelUT
  import BushelViewsCore
  import Foundation
  import SwiftData
  import SwiftUI

  public extension Scene {
    func registerSystems(
      _ systems: [System]
    ) -> some Scene {
      let (librarySystems, machineSystems, hubs) = systems.reduce(
        into: ([LibrarySystem](), [any MachineSystem](), [Hub]())
      ) { partialResult, system in
        if let library = system.library {
          partialResult.0.append(library)
        }
        if let machine = system.machine {
          partialResult.1.append(machine)
        }

        partialResult.2.append(contentsOf: system.hubs)
      }

      let machineSystemManager = MachineSystemManager(machineSystems)

      let librarySystemManager = LibrarySystemManager(
        librarySystems,
        fileTypeBasedOnURL: FileType.init(url:)
      )
      return self
        .metadataLabelProvider(librarySystemManager.labelForSystem)
        .environment(
          \.librarySystemManager,
          librarySystemManager
        )
        .environment(
          \.machineSystemManager,
          machineSystemManager
        )
        .environment(\.hubs, hubs)
    }

    func registerSystems(
      @SystemBuilder _ systems: @escaping () -> [System]
    ) -> some Scene {
      self.registerSystems(systems())
    }
  }
#endif
