//
// ServiceInterface.swift
// Copyright (c) 2024 BrightDigit.
//

public import DataThespian

public protocol ServiceInterface {
  #if canImport(SwiftData)
    var database: any Database {
      get
    }
  #endif
}
