//
// MachinePreparationState.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import SwiftUI

enum MachinePreparationState: Int, Identifiable {
  var id: RawValue {
    rawValue
  }

  case building
  case installing
}
