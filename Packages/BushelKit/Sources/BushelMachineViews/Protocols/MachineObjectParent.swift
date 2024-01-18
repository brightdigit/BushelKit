//
// MachineObjectParent.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

protocol MachineObjectParent: AnyObject {
  var error: MachineError? { get set }
}
