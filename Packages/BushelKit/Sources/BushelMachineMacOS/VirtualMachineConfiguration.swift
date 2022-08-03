//
// VirtualMachineConfiguration.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine
import Virtualization

struct VirtualMachineConfiguration: MachineConfiguration {
  let vzMachineConfiguration: VZVirtualMachineConfiguration
  let currentURL: URL
}
