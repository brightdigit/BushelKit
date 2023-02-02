//
// MachineFactoryView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineFactoryView: View {
    let phaseProgress: VirtualMachineBuildingProgress
    let onCancel: () -> Void
    func imageSystemNameBasedOn(_ value: Bool) -> String {
      value ? "play.fill" : "checkmark.circle.fill"
    }

    var body: some View {
      VStack {
        HStack {
          Image(systemName: self.imageSystemNameBasedOn(phaseProgress.phase == .building))
            .frame(width: 15, alignment: .leading)

          Text(.buildingMachine)
          Spacer()
        }.padding(.vertical, 8.0)
        HStack {
          Image(systemName: self.imageSystemNameBasedOn(phaseProgress.phase == .installing))
            .frame(width: 15, alignment: .leading)
          ProgressView(value: phaseProgress.percentCompleted ?? 0.0) {
            Text(.installingOs)
          }
        }.padding(.vertical, 8.0)
        HStack {
          Image(
            systemName: self.imageSystemNameBasedOn(phaseProgress.phase.hasSavedSuccessfully)
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
      MachineFactoryView(
        phaseProgress: .init(id: .init(), percentCompleted: nil, phase: .building),
        onCancel: {}
      ).previewLayout(.fixed(width: 300, height: 500))
    }
  }
#endif
