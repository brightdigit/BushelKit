//
// ArchKind.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum ArchKind: String, Codable, Equatable, Sendable {
  case archArm = "arch_arm"
  case archArmI64 = "arch_arm_i64"
  case archI64 = "arch_i64"
  case archOther = "arch_other"
}
