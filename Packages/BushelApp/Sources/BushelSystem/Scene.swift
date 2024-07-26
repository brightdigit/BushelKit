//
// Scene.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore

  public import BushelHub
  import BushelHubEnvironment

  public import BushelLibrary
  import BushelLibraryEnvironment

  public import BushelMachine
  import BushelMachineEnvironment
  import BushelUT
  import BushelViewsCore
  import Foundation
  import SwiftData

  public import SwiftUI

  extension Scene {
    public func register(
      _ librarySystemManager: LibrarySystemManager,
      _ machineSystemManager: MachineSystemManager,
      _ hubs: [Hub]
    ) -> some Scene {
      self
        .metadataLabelProvider(librarySystemManager.labelForSystem)
        .releaseCollectionProvider(librarySystemManager.releaseCollectionMetadata(forSystem:))
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

    public func registerSystems(
      _ systems: [any System]
    ) -> some Scene {
      let (librarySystems, machineSystems, hubs) = systems.reduce(
        into: ([any LibrarySystem](), [any MachineSystem](), [Hub]())
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
      return register(librarySystemManager, machineSystemManager, hubs)
    }

    public func registerSystems(
      @SystemBuilder _ systems: @escaping () -> [any System]
    ) -> some Scene {
      self.registerSystems(systems())
    }
  }
#endif
