//
// VirtualMachineBuildingProgress.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
public struct VirtualMachineBuildingProgress: Identifiable {
  public let id: UUID

  public let percentCompleted: Double?
  public let phase: VirtualMachineBuildingPhase

  public init(id: UUID, percentCompleted: Double?, phase: VirtualMachineBuildingPhase) {
    self.id = id
    self.percentCompleted = percentCompleted
    self.phase = phase
  }
}
