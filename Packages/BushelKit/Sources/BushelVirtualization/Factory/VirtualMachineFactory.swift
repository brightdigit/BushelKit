//
// VirtualMachineFactory.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol VirtualMachineFactory: AnyObject {
  var state: VirtualMachineBuildingProgress { get }
  var delegate: VirtualMachineFactoryDelegate? { get set }
  func beginBuild(at url: URL)
}
