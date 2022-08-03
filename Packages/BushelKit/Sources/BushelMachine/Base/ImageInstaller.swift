//
// ImageInstaller.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

public protocol ImageInstaller {
  func beginInstaller(configuration: MachineConfiguration) throws -> VirtualInstaller
  func setupMachine(_ machine: Machine) throws -> MachineConfiguration
}
