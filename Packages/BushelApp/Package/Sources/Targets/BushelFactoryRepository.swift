//
// BushelFactoryRepository.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelFactoryRepository: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelData()
    BushelLibrary()
    BushelMachine()
    BushelLogging()
  }
}
