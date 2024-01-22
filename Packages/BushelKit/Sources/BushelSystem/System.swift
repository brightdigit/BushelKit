//
// System.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import BushelLibrary
import BushelMachine
import Foundation

public protocol System {
  var library: (any LibrarySystem)? { get }
  var machine: (any MachineSystem)? { get }
  var hubs: [Hub] { get }
}

public extension System {
  var library: (any LibrarySystem)? {
    nil
  }

  var machine: (any MachineSystem)? {
    nil
  }

  var hubs: [Hub] {
    []
  }
}
