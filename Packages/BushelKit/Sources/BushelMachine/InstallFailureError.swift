//
// InstallFailureError.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public protocol InstallFailureError: Error {
  func installationFailure() -> InstallFailure?
}
