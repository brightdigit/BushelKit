//
// BasicWindowOpenHandle.swift
// Copyright (c) 2023 BrightDigit.
//

enum BasicWindowOpenHandle: String, CaseIterable, InstanceConditionalHandle {
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

  var path: String? {
    nil
  }
}
