//
// StorageDevicesView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import BushelMachine
  import SwiftUI

  internal struct StorageDevicesView: View {
    let storageDevice: MachineStorageSpecification
    var body: some View {
      MachineSpecView(
        systemName: "internaldrive.fill"
      ) {
        Text(.machineDetailsStorageName)
      } value: {
        Text(
          ByteCountFormatStyle.FormatInput(storageDevice.size), format: .byteCount(style: .file)
        )
      }
    }
  }

  internal struct StorageDevicesView_Previews: PreviewProvider {
    static var previews: some View {
      StorageDevicesView(
        storageDevice:
        .init(
          id: .init(),
          label: "Lorem Ipsum",
          size: 256 * 1_024 * 1_024 * 1_024
        )
      )
    }
  }
#endif
