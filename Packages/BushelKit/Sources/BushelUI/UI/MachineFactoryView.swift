//
// MachineFactoryView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineFactoryView: View {
    let phaseProgress: VirtualMachineBuildingProgress
    var body: some View {
      VStack {
        HStack {
          Image(systemName: phaseProgress.phase == .building ? "play.fill" : "checkmark.circle.fill")
          Text(.buildingMachine)
        }
        HStack {
          Image(systemName: phaseProgress.phase == .installing ? "play.fill" : "checkmark.circle.fill")
          ProgressView(value: phaseProgress.percentCompleted ?? 0.0) {
            Text(.installingOs)
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
#endif
