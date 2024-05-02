//
// MachineConfigurable.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation
public protocol MachineConfigurable {
  var machineSystem: (any MachineSystem)? { get }
  var selectedBuildImage: SelectedVersion { get }
  var specificationConfiguration: SpecificationConfiguration? { get }
}
