//
// TimeoutError.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

internal struct TimeoutError: Error {
  let timeout: DispatchTime
}
