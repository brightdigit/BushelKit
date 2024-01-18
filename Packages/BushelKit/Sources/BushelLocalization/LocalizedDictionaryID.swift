//
// LocalizedDictionaryID.swift
// Copyright (c) 2024 BrightDigit.
//

public enum LocalizedDictionaryID: String, LocalizedID {
  case cpuCount = "%d CPUS"
  case displayResolution = "%d x %d %dppi"

  public var keyValue: String {
    rawValue
  }
}
