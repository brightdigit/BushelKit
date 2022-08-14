//
// DirectoryExists.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
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
