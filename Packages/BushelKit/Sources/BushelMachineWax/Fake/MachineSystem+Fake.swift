//
// MachineSystem+Fake.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachine
import Foundation

public extension MachineSystem where Self == MachineSystemStub {
  static var stubOS1: Self { MachineSystemStub(id: .init(stringLiteral: "stubOS1")) }
  static var stubOS2: Self { MachineSystemStub(id: .init(stringLiteral: "stubOS2")) }
  static var stubOS3: Self { MachineSystemStub(id: .init(stringLiteral: "stubOS3")) }
}
