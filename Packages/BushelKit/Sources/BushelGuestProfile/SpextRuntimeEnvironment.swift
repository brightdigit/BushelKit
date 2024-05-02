//
// SpextRuntimeEnvironment.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum SpextRuntimeEnvironment: String, Codable, Equatable, Sendable {
  case spextArchX86 = "spext_arch_x86"
  case spextUniversal = "spext_universal"
  case spextUnknown = "spext_unknown"
}
