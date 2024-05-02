//
// SpecificationsView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
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

        MachineSpecView(
          systemName: "cpu.fill"
        ) {
          Text(LocalizedStringID.machineDetailsChip)
        } value: {
          Text(localizedUsingID: LocalizedDictionaryID.cpuCount, arguments: configuration.cpuCount)
        }

        MachineSpecView(
          systemName: "memorychip.fill"
        ) {
          Text(LocalizedStringID.machineDetailsMemorySize)
        } value: {
          Text(
            ByteCountFormatStyle.FormatInput(configuration.memory),
            format: .byteCount(style: .memory)
          )
        }

        ForEach(self.configuration.storage) {
          StorageDevicesView(storageDevice: $0)
        }

        ForEach(
          self.configuration.graphicsConfigurations
        ) { config in
          ForEach(config.displays) { display in
            MachineSpecView(
              systemName: "display"
            ) {
              Text(.machineDetailsDisplay)
            } value: {
              Text(
                localizedUsingID: LocalizedDictionaryID.displayResolution,
                arguments: display.widthInPixels,
                display.heightInPixels,
                display.pixelsPerInch
              )
            }
          }
        }

        ForEach(self.configuration.networkConfigurations) { _ in
          MachineSpecView(
            systemName: "network"
          ) {
            Text(LocalizedStringID.machineDetailsNetworkName)
          } value: {
            Text(.machineDetailsNetworkNat)
          }
        }
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
        vmSystemID: "cheese",
        snapshotSystemID: .init(stringLiteral: ""),
        operatingSystemVersion: .init(majorVersion: 15, minorVersion: 0, patchVersion: 1),
        buildVersion: "test",
        storage: [.init(label: "preview", size: 800_000_000_000)]
      )
    )
  }
#endif
