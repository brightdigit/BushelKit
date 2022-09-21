//
// AnyImageManagers.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelMachine
  import Foundation

  public extension AnyImageManagers {
    static let vzMacOS: AnyImageManager = VirtualizationImageManager()
  }
#endif
