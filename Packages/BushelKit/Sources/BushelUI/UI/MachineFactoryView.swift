//
// MachineFactoryView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineFactoryView: View {
    let phaseProgress: VirtualMachineBuildingProgress
    let onCancel: () -> Void
    var body: some View {
      VStack {
        HStack {
          Image(systemName: phaseProgress.phase == .building ? "play.fill" : "checkmark.circle.fill").frame(width: 15, alignment: .leading)

          Text(.buildingMachine)
          Spacer()
        }.padding(.vertical, 8.0)
        HStack {
          Image(systemName: phaseProgress.phase == .installing ? "play.fill" : "checkmark.circle.fill").frame(width: 15, alignment: .leading)
          ProgressView(value: phaseProgress.percentCompleted ?? 0.0) {
            Text(.installingOs)
          }
        }.padding(.vertical, 8.0)
        HStack {
          Image(
            systemName:
            phaseProgress.phase.hasSavedSuccessfully ? "play.fill" : "checkmark.circle.fill"
          ).frame(width: 15, alignment: .leading)
          Text(.savingMachine)
          Spacer()
        }.padding(.vertical, 8.0)

        HStack {
          Spacer()
          Button(.cancel, action: self.onCancel)
        }
      }.padding()
    }
  }

  struct MachineFactoryView_Previews: PreviewProvider {
    static var previews: some View {
      MachineFactoryView(phaseProgress: .init(id: .init(), percentCompleted: nil, phase: .building), onCancel: {}).previewLayout(.fixed(width: 300, height: 500))
    }
  }
#endif
