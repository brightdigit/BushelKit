//
// MachinePreparationState.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/5/22.
//

import SwiftUI

@available(*, deprecated)
enum MachinePreparationState: Int, Identifiable {
  var id: RawValue {
    rawValue
  }

  case building
  case installing
}
