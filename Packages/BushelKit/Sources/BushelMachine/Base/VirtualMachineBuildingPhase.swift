//
// VirtualMachineBuildingPhase.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import Combine
import Foundation

public enum VirtualMachineBuildingPhase: Equatable {
  public static func == (lhs: VirtualMachineBuildingPhase, rhs: VirtualMachineBuildingPhase) -> Bool {
    switch (lhs, rhs) {
    case (.notStarted, .notStarted): return true
    case (.building, .building): return true
    case (.installing, .installing): return true
    case let (.completed(lhsResult), .completed(rhsResult)): return (try? lhsResult.get()) == (try? rhsResult.get())
    default: return false
    }
  }

  case notStarted
  case building
  case installing
  case completed(Result<URL, Error>)
}
