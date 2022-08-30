//
// BasicWindowOpenHandle.swift
// Copyright (c) 2022 BrightDigit.
//

enum BasicWindowOpenHandle: String, CaseIterable, InstanceConditionalHandle {
  var path: String? {
    nil
  }

  case machine
  case localImages
  case remoteSources
  case welcome
  case onboarding
  case purchase

  var host: String {
    rawValue
  }

  var conditions: Set<String> {
    [rawValue]
  }
}
