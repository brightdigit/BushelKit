//
// VirtualMachineFactoryDelegate.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol VirtualMachineFactoryDelegate: AnyObject {
  func factory(
    _ factory: VirtualMachineFactory,
    didChangeState state: VirtualMachineBuildingProgress
  )
}
