//
// ConfigurationError.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import Foundation
public enum ConfigurationError: Error {
  case missingRestoreImageID
  case missingSystemManager
  case restoreImageNotFound(UUID, library: LibraryIdentifier?)
}
