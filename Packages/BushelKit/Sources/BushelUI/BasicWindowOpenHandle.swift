//
// BasicWindowOpenHandle.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/13/22.
//

enum BasicWindowOpenHandle: String, CaseIterable, InstanceConditionalHandle {
  var path: String? {
    nil
  }

  case machine
  case localImages
  case remoteSources
  case welcome

  var host: String {
    rawValue
  }

  var conditions: Set<String> {
    [rawValue]
  }
}
