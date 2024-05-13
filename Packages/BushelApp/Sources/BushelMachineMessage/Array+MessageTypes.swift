//
// Array+MessageTypes.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelMachineData
import BushelMessageCore

#if canImport(SwiftData)
  private let _messageTypes: [any Message.Type] = [
    MachineNameListRequest.self
  ]
#else
  private let _messageTypes: [any Message.Type] = []
#endif

extension Array where Element == any Message.Type {
  public static var machine: [any Message.Type] {
    _messageTypes
  }
}
