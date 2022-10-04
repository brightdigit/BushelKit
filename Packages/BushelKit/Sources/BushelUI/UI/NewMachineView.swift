//
// NewMachineView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct NewMachineView: View {
    @State var isDisabled = false
    @State var requestedRestoreImageURL: URL?
    @State var document = MachineDocument()
    @State var machineRestoreImage: MachineRestoreImage?
    var body: some View {
      MachineSetupView(
        machineRestoreImage: self.machineRestoreImage,
        document: self.$document,
        url: nil, restoreImageChoices: [machineRestoreImage].compactMap { $0 }, onCompleted: { error in
          if let error = error {
            Self.logger.error("machine setup error: \(error.localizedDescription)")
          }
        }
      ).disabled(self.isDisabled)
        .onOpenURL { externalURL in
          Task {
            await MainActor.run {
              self.isDisabled = true
            }
          }

          let actualURL: URL
          do {
            actualURL = try MachineSetupWindowHandle.actualURL(fromExternalURL: externalURL)
          } catch {
            Self.logger.error("invalid externalURL: \(externalURL): \(error.localizedDescription)")
            return
          }
          Task {
            await MainActor.run {
              self.requestedRestoreImageURL = actualURL
            }
          }
        }.task(id: self.requestedRestoreImageURL) {
          guard let url = requestedRestoreImageURL else {
            return
          }
          let restoreImage = await AnyImageManagers.restoreImageFrom(accessor: URLAccessor(url: url), using: FileRestoreImageLoader())
          guard let restoreImage = restoreImage else {
            return
          }

          guard let file =
            RestoreImageLibraryItemFile(loadFromImage: restoreImage) else {
            return
          }

          await MainActor.run {
            self.machineRestoreImage = MachineRestoreImage(file: file)
            self.document.machine.restoreImage = file
            self.isDisabled = false
          }
        }
    }
  }

  struct NewMachineView_Previews: PreviewProvider {
    static var previews: some View {
      NewMachineView()
    }
  }
#endif
