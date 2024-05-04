//
// MachineConfigurable.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation
public protocol MachineConfigurable {
  associatedtype Name: Hashable
  var machineSystem: (any MachineSystem)? { get }
  var selectedBuildImage: SelectedVersion { get }
  var specificationConfiguration: SpecificationConfiguration<Name>? { get }
}
