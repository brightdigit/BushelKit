//
// MachineFactoryView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

import BushelMachine
import SwiftUI

struct MachineFactoryView: View {
  let phaseProgress: VirtualMachineBuildingProgress
  var body: some View {
    VStack {
      HStack {
        Image(systemName: phaseProgress.phase == .building ? "play.fill" : "checkmark.circle.fill")
        Text("Building Machine...")
      }
      HStack {
        Image(systemName: phaseProgress.phase == .installing ? "play.fill" : "checkmark.circle.fill")
        ProgressView(value: phaseProgress.percentCompleted ?? 0.0) {
          Text("Installing Operating System...")
        }
      }
    }
  }
}

struct MachineFactoryView_Previews: PreviewProvider {
  static var previews: some View {
    MachineFactoryView(phaseProgress: .init(id: .init(), percentCompleted: nil, phase: .building))
  }
}
