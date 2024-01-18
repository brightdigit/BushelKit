//
// BushelArgs.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelArgs: Target {
  var dependencies: any Dependencies {
    ArgumentParser()
    BushelCore()
  }
}
