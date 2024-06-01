//
// MachineObjectParent.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

@MainActor
internal protocol MachineObjectParent: AnyObject {
  @MainActor
  var error: MachineError? { get set }

  var allowedToSaveSnapshot: Bool { get }
}
