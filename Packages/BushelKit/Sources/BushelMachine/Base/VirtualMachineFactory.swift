//
// VirtualMachineFactory.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public protocol VirtualMachineFactory: AnyObject {
  func beginBuild(at url: URL)
  var state: VirtualMachineBuildingProgress { get }
  var delegate: VirtualMachineFactoryDelegate? { get set }
}
