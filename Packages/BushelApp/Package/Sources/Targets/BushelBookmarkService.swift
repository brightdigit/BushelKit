//
// BushelBookmarkService.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelBookmarkService: Target {
  var dependencies: any Dependencies {
    BushelCore()
    BushelLogging()
    BushelDataCore()
    DataThespian()
  }
}
