//
// MockInstaller.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine

struct MockInstaller: ImageInstaller {
  func setupMachine(_: Machine) throws -> MachineConfiguration {
    fatalError()
  }

  func beginInstaller(configuration _: MachineConfiguration) throws -> VirtualInstaller {
    fatalError()
  }
}
