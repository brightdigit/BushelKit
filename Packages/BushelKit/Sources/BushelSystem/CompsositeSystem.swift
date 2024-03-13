//
// CompsositeSystem.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import BushelLibrary
import BushelMachine

struct CompsositeSystem: System {
  let libraryClosure: (@Sendable () -> any LibrarySystem)?
  let machineClosure: (@Sendable () -> any MachineSystem)?
  let hubsClosure: (@Sendable () -> [Hub])?
  var library: (any LibrarySystem)? {
    self.libraryClosure?()
  }

  var machine: (any MachineSystem)? {
    self.machineClosure?()
  }

  var hubs: [Hub] {
    self.hubsClosure?() ?? [Hub]()
  }

  internal init(
    libraryClosure: (@Sendable () -> any LibrarySystem)? = nil,
    machineClosure: (@Sendable () -> any MachineSystem)? = nil,
    hubsClosure: (@Sendable () -> [Hub])? = nil
  ) {
    self.libraryClosure = libraryClosure
    self.machineClosure = machineClosure
    self.hubsClosure = hubsClosure
  }
}
