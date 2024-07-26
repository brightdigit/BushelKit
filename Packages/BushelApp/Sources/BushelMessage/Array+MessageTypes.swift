//
// Array+MessageTypes.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelMessageCore
import Foundation

extension Array where Element == any Message.Type {
  public static var all: [any Message.Type] {
    [Array.machine].flatMap { $0 }
  }
}
