//
// CompsositeSystem.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelHub
import BushelLibrary
import BushelMachine

struct CompsositeSystem: System {
  let libraryClosure: (() -> LibrarySystem)?
  let machineClosure: (() -> any MachineSystem)?
  let hubsClosure: (() -> [Hub])?
  var library: LibrarySystem? {
    self.libraryClosure?()
  }

  var machine: (any MachineSystem)? {
    self.machineClosure?()
  }

  var hubs: [Hub] {
    self.hubsClosure?() ?? [Hub]()
  }

  internal init(
    libraryClosure: (() -> LibrarySystem)? = nil,
    machineClosure: (() -> any MachineSystem)? = nil,
    hubsClosure: (() -> [Hub])? = nil
  ) {
    self.libraryClosure = libraryClosure
    self.machineClosure = machineClosure
    self.hubsClosure = hubsClosure
  }
}
