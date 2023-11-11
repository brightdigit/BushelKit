//
// InstallFailureError.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation

public protocol InstallFailureError: Error {
  func installationFailure() -> InstallFailure?
}
