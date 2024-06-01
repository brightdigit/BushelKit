//
// BushelWishListEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelWishListEnvironment: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelEnvironmentCore()
  }
}
