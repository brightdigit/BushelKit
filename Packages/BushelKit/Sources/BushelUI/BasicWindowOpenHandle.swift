//
// BasicWindowOpenHandle.swift
// Copyright (c) 2023 BrightDigit.
//

enum BasicWindowOpenHandle: String, CaseIterable, InstanceConditionalHandle {
  var path: String? {
    nil
  }

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
