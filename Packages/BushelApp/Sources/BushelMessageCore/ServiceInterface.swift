//
// ServiceInterface.swift
// Copyright (c) 2024 BrightDigit.
//

public import BushelDataCore

public protocol ServiceInterface: Sendable {
  #if canImport(SwiftData)
    var database: any Database {
      get
    }
  #endif
}
