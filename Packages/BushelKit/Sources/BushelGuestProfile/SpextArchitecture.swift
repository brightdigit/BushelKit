//
// SpextArchitecture.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum SpextArchitecture: String, Codable, Equatable, Sendable {
  case arm64
  case arm64E = "arm64e"
  case x8664 = "x86_64"
}
