//
// SpecificationsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelMachine
  import SwiftUI

  struct SpecificationsView: View {
    let label: MetadataLabel
    let configuration: MachineConfiguration
    var body: some View {
      VStack(alignment: .leading) {
        HStack {
          Text(label.systemName).fontWeight(.black)
          Text(label.versionName)
        }.font(.system(size: 32))

        HStack(spacing: 3.0) {
          Text(.version).fontWeight(.light)
          Text(configuration.operatingSystemVersion.description).fontWeight(.light)
          if let buildVersion = configuration.buildVersion {
            Text(buildVersion).fontWeight(.light)
          }
        }.font(.system(size: 14.0))

        //        MachineSpecView(systemName: "cpu.fill") {
        //          Text(.machineDetailsChip)
        //        } value: {
        //          Text(
        //            String(
        //              format: NSLocalizedString(
        // "%d CPUS", bundle: .module, comment: ""), specification.cpuCount
        //            )
        //          )
        //        }
        //
        //        MachineSpecView(systemName: "memorychip.fill") {
        //          Text(.machineDetailsMemory)
        //        } value: {
        //          Text(
        //            ByteCountFormatStyle.FormatInput(specification.memorySize),
        //            format: .byteCount(style: .memory)
        //          )
        //        }
        //
        //        ForEach(self.specification.storageDevices) {
        //          StorageDevicesView(storageDevice: $0)
        //        }
        //
        //        ForEach(self.specification.graphicsConfigurations) { config in
        //          ForEach(config.displays) { display in
        //            MachineSpecView(systemName: "display") {
        //              Text(.machineDetailsDisplay)
        //            } value: {
        //              Text(
        //                String(
        //                  format: NSLocalizedString("%d x %d %dppi", bundle: .module, comment: ""),
        //                  display.widthInPixels, display.heightInPixels, display.pixelsPerInch
        //                )
        //              )
        //            }
        //          }
        //        }
        //
        //        ForEach(self.specification.networkConfigurations) { _ in
        //          MachineSpecView(systemName: "network") {
        //            Text(.machineDetailsNetwork)
        //          } value: {
        //            Text(.machineDetailsNetworkNat)
        //          }
        //        }
      }
    }

    internal init(label: MetadataLabel, configuration: MachineConfiguration) {
      self.label = label
      self.configuration = configuration
    }
  }

  #Preview {
    SpecificationsView(
      label: .init(
        operatingSystemLongName: "macOS Pacific",
        defaultName: "macOS Pacific",
        imageName: "OSVersions/Sonoma",
        systemName: "macOS",
        versionName: "Pacific"
      ),
      configuration: .init(
        restoreImageFile: .init(imageID: .init()),
        systemID: "cheese",
        operatingSystemVersion: .init(majorVersion: 15, minorVersion: 0, patchVersion: 1),
        buildVersion: "test"
      )
    )
  }
#endif
