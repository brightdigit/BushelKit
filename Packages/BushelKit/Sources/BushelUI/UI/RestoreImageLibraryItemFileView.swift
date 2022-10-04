//
// RestoreImageLibraryItemFileView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct RestoreImageLibraryItemFileView: View {
    @Binding var file: RestoreImageLibraryItemFile
    var body: some View {
      VStack(alignment: .leading) {
        TextField("Name", text: self.$file.name).font(.largeTitle)
        HStack {
          Image(
            operatingSystemVersion: file.metadata.operatingSystemVersion
          )
          .resizable()
          .aspectRatio(1.0, contentMode: .fit)
          .frame(height: 80.0)
          .mask {
            Circle()
          }
          .overlay {
            Circle().stroke()
          }
          VStack(alignment: .leading) {
            Text(
              // swiftlint:disable:next line_length
              "macOS \(OperatingSystemCodeName(operatingSystemVersion: file.metadata.operatingSystemVersion)?.name ?? "")"
            )
            .font(.title)

            Text(file.metadata.localizedVersionString)
            Text(self.file.metadata.lastModified, style: .date)
          }
        }
        Button {
          guard let fileAccessor = file.fileAccessor else {
            Self.logger.error("invalid restore image for machine \(file.name)")
            return
          }
          let restoreImagePath: MachineSetupWindowHandle.RestoreImagePath
          do {
            let url = try fileAccessor.getURL()
            restoreImagePath = try MachineSetupWindowHandle.externalURL(fromActualURL: url)
          } catch {
            Self.logger.error("unable to get restore image path: \(error.localizedDescription)")
            return
          }
          Windows.openWindow(withHandle: MachineSetupWindowHandle(restoreImagePath: restoreImagePath))
        } label: {
          Image(systemName: "hammer.fill")
          Text(.buildMachine)
        }
      }.padding()
    }
  }

  #if canImport(Virtualization) && arch(arm64)
    struct RestoreImageLibraryItemFileView_Previews: PreviewProvider {
      static var previews: some View {
        RestoreImageLibraryItemFileView(
          file: .constant(
            .init(
              id: .init(),
              metadata: .Previews.venturaBeta3,
              name: "venturaBeta3",
              fileAccessor:
              URLAccessor(
                url: .init(
                  fileURLWithPath: "/Users/leo/Documents/Restore Images/RestoreImage.ipsw"
                )
              )
            )
          )
        )
      }
    }
  #endif
#endif
