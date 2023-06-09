//
// StorageDevicesView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelVirtualization
  import SwiftUI

  struct StorageDevicesView: View {
    let storageDevice: MachineStorageSpecification
    var body: some View {
      MachineSpecView(systemName: "internaldrive.fill") {
        Text(.machineDetailsStorage)
      } value: {
        Text(
          ByteCountFormatStyle.FormatInput(storageDevice.size), format: .byteCount(style: .file)
        )
      }
    }
  }

  struct StorageDevicesView_Previews: PreviewProvider {
    static var previews: some View {
      StorageDevicesView(
        storageDevice: .init(
          id: .init(), label: "Lorem Ipsum",
          size: 256 * 1024 * 1024 * 1024
        )
      )
    }
  }
#endif
