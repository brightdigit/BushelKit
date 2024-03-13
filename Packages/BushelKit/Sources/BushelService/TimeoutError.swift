//
// TimeoutError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

struct TimeoutError: Error {
  let timeout: DispatchTime
}
