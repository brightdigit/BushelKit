//
// BushelHubIPSW.swift
// Copyright (c) 2024 BrightDigit.
//

struct BushelHubIPSW: Target {
  var dependencies: any Dependencies {
    BushelHub()
    IPSWDownloads()
    BushelLogging()
    BushelMacOSCore()
  }
}