//
// BushelUITestingUtilities.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelUITestingUtilities: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelAccessibility()
  }
}
