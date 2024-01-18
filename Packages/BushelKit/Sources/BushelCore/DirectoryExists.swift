//
// DirectoryExists.swift
// Copyright (c) 2024 BrightDigit.
//

public enum DirectoryExists {
  case directoryExists
  case fileExists
  case notExists
}

public extension DirectoryExists {
  init(fileExists: Bool, isDirectory: Bool) {
    if fileExists {
      self = isDirectory ? .directoryExists : .fileExists
    } else {
      self = .notExists
    }
  }
}
