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
        machineLabel()

        osLabel()

        cpuSpecifications()

        memorySpecifications()

        storage()

        graphics()

        network()
      }
    }

    internal init(label: MetadataLabel, configuration: MachineConfiguration) {
      self.label = label
      self.configuration = configuration
    }

    private func machineLabel() -> some View {
      HStack {
        Text(label.systemName).fontWeight(.black)
        Text(label.versionName)
      }.font(.system(size: 32))
    }

    private func osLabel() -> some View {
      HStack(spacing: 3.0) {
        Text(.version).fontWeight(.light)
        Text(configuration.operatingSystemVersion.description).fontWeight(.light)
        if let buildVersion = configuration.buildVersion {
          Text(buildVersion).fontWeight(.light)
        }
      }.font(.system(size: 14.0))
    }

    private func cpuSpecifications() -> MachineSpecView {
      MachineSpecView(
        systemName: "cpu.fill"
      ) {
        Text(LocalizedStringID.machineDetailsChip)
      } value: {
        Text(localizedUsingID: LocalizedDictionaryID.cpuCount, arguments: configuration.cpuCount)
      }
    }

    private func memorySpecifications() -> MachineSpecView {
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
    }

    private func graphics() -> some View {
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
    }

    private func network() -> ForEach<[NetworkConfiguration], UUID, MachineSpecView> {
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

    private func storage() -> ForEach<[MachineStorageSpecification], UUID, StorageDevicesView> {
      ForEach(self.configuration.storage) {
        StorageDevicesView(storageDevice: $0)
      }
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
