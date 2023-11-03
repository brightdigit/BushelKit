//
// BushelUITestingUtilities.swift
// Copyright (c) 2023 BrightDigit.
//

struct BushelUITestingUtilities: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelAccessibility()
  }
}
