//
// CompsositeSystem.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import BushelLibrary
import BushelMachine

struct CompsositeSystem: System {
  let libraryClosure: (() -> any LibrarySystem)?
  let machineClosure: (() -> any MachineSystem)?
  let hubsClosure: (() -> [Hub])?
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
    libraryClosure: (() -> any LibrarySystem)? = nil,
    machineClosure: (() -> any MachineSystem)? = nil,
    hubsClosure: (() -> [Hub])? = nil
  ) {
    self.libraryClosure = libraryClosure
    self.machineClosure = machineClosure
    self.hubsClosure = hubsClosure
  }
}
