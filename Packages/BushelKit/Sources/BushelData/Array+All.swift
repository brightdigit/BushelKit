//
// Array+All.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import SwiftData

  public extension Array where Element == any PersistentModel.Type {
    static var all: [any PersistentModel.Type] {
      [core, library, .machine].flatMap { $0 }
    }
  }
#endif
