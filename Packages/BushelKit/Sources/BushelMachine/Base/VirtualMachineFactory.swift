//
// VirtualMachineFactory.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import Foundation

public protocol VirtualMachineFactory: AnyObject {
  func beginBuild()
  var state: VirtualMachineBuildingProgress { get }
  var delegate: VirtualMachineFactoryDelegate? { get set }
}
