//
// System.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelHub
import BushelLibrary
import BushelMachine
import Foundation

public protocol System {
  var library: LibrarySystem? { get }
  var machine: (any MachineSystem)? { get }
  var hubs: [Hub] { get }
}

public extension System {
  var library: LibrarySystem? {
    nil
  }

  var machine: (any MachineSystem)? {
    nil
  }

  var hubs: [Hub] {
    []
  }
}
