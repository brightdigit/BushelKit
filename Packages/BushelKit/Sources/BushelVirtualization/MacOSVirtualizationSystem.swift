//
// MacOSVirtualizationSystem.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelHubMacOS
  import BushelLibraryMacOS
  import BushelMachineMacOS

  import BushelHub
  import BushelLibrary
  import BushelMachine
  import BushelSystem

  public struct MacOSVirtualizationSystem: System, MacOSVirtualizationHubProvider {
    public init() {}

    public var library: LibrarySystem {
      MacOSVirtualizationLibrarySystem()
    }

    public var machine: any MachineSystem {
      MacOSVirtualizationMachineSystem()
    }
  }
#endif
