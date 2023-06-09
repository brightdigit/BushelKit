//
// FileCreationError.swift
// Copyright (c) 2023 BrightDigit.
//

struct FileCreationError: Error {
  enum ErrorType {
    case open
    case ftruncate
    case close
  }

  let code: Int
  let type: ErrorType
}
