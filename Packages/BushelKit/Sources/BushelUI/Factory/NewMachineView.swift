//
// NewMachineView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct NewMachineView: View {
    @State var shouldDisplayError = false
    @State var machineSetupError: Error?
    @State var isDisabled = false
    @State var restoreImagePath: RestoreImagePath?
    // @State var document = MachineDocument()
    @State var machineRestoreImageID: UUID

    var body: some View {
      MachineSetupView(
        machineRestoreImageID: self.$machineRestoreImageID,

        onCompleted: { error in
          if let error = error {
            Self.logger.error("machine setup error: \(error.localizedDescription)")
          }
          #warning("Swap for MainActor")
          DispatchQueue.main.async {
            self.machineSetupError = error
            self.shouldDisplayError = error != nil
          }
        }
      )

      .alert(
        Text(.buildingMachineFailure),
        isPresented: self.$shouldDisplayError,
        presenting: self.machineSetupError,
        actions: { _ in
          Button("OK") {}
        }, message: { error in
          Text(error.localizedDescription)
        }
      )
      .disabled(self.isDisabled)
      .onOpenURL { externalURL in
        Task {
          await MainActor.run {
            self.isDisabled = true
          }
        }

        let restoreImagePath: RestoreImagePath
        do {
          guard let riPath = try RestoreImagePath(externalURL: externalURL) else {
            Task {
              await MainActor.run {
                self.isDisabled = false
              }
            }
            return
          }
          restoreImagePath = riPath
        } catch {
          Self.logger.error("invalid externalURL: \(externalURL): \(error.localizedDescription)")
          return
        }
        Task {
          await MainActor.run {
            self.restoreImagePath = restoreImagePath
          }
        }
      }
      .task(id: self.restoreImagePath) {
        guard let restoreImagePath = restoreImagePath else {
          return
        }

        await MainActor.run {
          self.machineRestoreImageID = restoreImagePath.imageID
          self.isDisabled = false
        }
      }
    }

    internal init(machineRestoreImageID: UUID) {
      _machineRestoreImageID = .init(initialValue: machineRestoreImageID)
    }
  }

  struct NewMachineView_Previews: PreviewProvider {
    static var previews: some View {
      NewMachineView(machineRestoreImageID: .init())
    }
  }
#endif
