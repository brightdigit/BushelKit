//
// VirtualMachineFactoryDelegate.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import Foundation

public protocol VirtualMachineFactoryDelegate: AnyObject {
  func factory(_ factory: VirtualMachineFactory, didChangeState state: VirtualMachineBuildingProgress)
}
