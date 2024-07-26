//
// MacOSVirtualizationSystem.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelHubMacOS
  import BushelLibraryMacOS
  import BushelMachineMacOS

  public import BushelCore

  public import BushelHub

  public import BushelLibrary

  public import BushelMachine
  import BushelSystem

  public struct MacOSVirtualizationSystem: System, MacOSVirtualizationHubProvider {
    public static var systemID: VMSystemID {
      .macOS
    }

    public var library: (any LibrarySystem)? {
      MacOSVirtualizationLibrarySystem()
    }

    public var machine: (any MachineSystem)? {
      MacOSVirtualizationMachineSystem()
    }

    public var hubs: [Hub] {
      macOSHubs
    }

    public init() {}
  }
#endif
