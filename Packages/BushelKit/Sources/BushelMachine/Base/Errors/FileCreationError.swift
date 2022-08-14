//
// FileCreationError.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
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
