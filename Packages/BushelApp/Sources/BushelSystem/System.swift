//
// System.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import BushelLibrary
import BushelMachine
import Foundation

public protocol System: Sendable {
  var library: (any LibrarySystem)? { get }
  var machine: (any MachineSystem)? { get }
  var hubs: [Hub] { get }
}

extension System {
  public var library: (any LibrarySystem)? {
    nil
  }

  public var machine: (any MachineSystem)? {
    nil
  }

  public var hubs: [Hub] {
    []
  }
}
