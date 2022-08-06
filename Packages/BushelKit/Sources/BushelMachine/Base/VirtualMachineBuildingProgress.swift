//
// VirtualMachineBuildingProgress.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import Foundation
public struct VirtualMachineBuildingProgress: Identifiable {
  public let id: UUID

  public init(id: UUID, percentCompleted: Double?, phase: VirtualMachineBuildingPhase) {
    self.id = id
    self.percentCompleted = percentCompleted
    self.phase = phase
  }

  public let percentCompleted: Double?
  public let phase: VirtualMachineBuildingPhase
}
