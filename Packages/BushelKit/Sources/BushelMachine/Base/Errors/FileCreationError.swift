//
// FileCreationError.swift
// Copyright (c) 2022 BrightDigit.
//

struct FileCreationError: Error {
  let code: Int
  let type: ErrorType

  enum ErrorType {
    case open
    case ftruncate
    case close
  }
}
