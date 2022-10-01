//
// RestoreImageLibraryItemFileView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct RestoreImageLibraryItemFileView: View {
    @Binding var file: RestoreImageLibraryItemFile
    @State var newMachine: MachineDocument?
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
          self.newMachine = MachineDocument(machine: .init(restoreImage: file))
        } label: {
          Image(systemName: "hammer.fill")
          Text(.buildMachine)
        }
      }.padding().sheet(item: self.$newMachine) { machine in
        let mri = MachineRestoreImage(file: self.file)
        MachineSetupView(
          machineRestoreImage: mri,
          document: .init(
            get: {
              machine
            },
            set: { document in
              self.newMachine = document
            }
          ),
          url: nil,
          restoreImageChoices: [mri],
          onCompleted: { _ in
            self.newMachine = nil
          }
        )
      }
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
