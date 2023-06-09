//
// MachineSpecListView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachineMacOS
  import BushelVirtualization
  import SwiftUI

  struct MachineSpecListView: View {
    let specification: MachineSpecification
    let operatingSystem: OperatingSystemDetails
    let previewImageManager: AnyImageManager?

    var imageManager: AnyImageManager? {
      previewImageManager ?? AnyImageManagers.imageManager(forOperatingSystem: operatingSystem.type)
    }

    var body: some View {
      VStack(alignment: .leading) {
        HStack {
          Text(operatingSystem.type.rawValue).fontWeight(.black)
          Text(
            imageManager?.codeNameFor(
              operatingSystemVersion: operatingSystem.version
            ) ?? "\(operatingSystem.version.majorVersion)"
          )
        }.font(.custom("Raleway", size: 32.0))

        HStack(spacing: 3.0) {
          Text(.version).fontWeight(.light)
          Text(self.operatingSystem.version.description).fontWeight(.light)
          Text(self.operatingSystem.buildVersion).fontWeight(.light)
        }.font(.custom("Raleway", size: 14.0))

        MachineSpecView(systemName: "cpu.fill") {
          Text(.machineDetailsChip)
        } value: {
          Text(
            String(
              format: NSLocalizedString("%d CPUS", bundle: .module, comment: ""), specification.cpuCount
            )
          )
        }

        MachineSpecView(systemName: "memorychip.fill") {
          Text(.machineDetailsMemory)
        } value: {
          Text(
            ByteCountFormatStyle.FormatInput(specification.memorySize),
            format: .byteCount(style: .memory)
          )
        }

        ForEach(self.specification.storageDevices) {
          StorageDevicesView(storageDevice: $0)
        }

        ForEach(self.specification.graphicsConfigurations) { config in
          ForEach(config.displays) { display in
            MachineSpecView(systemName: "display") {
              Text(.machineDetailsDisplay)
            } value: {
              Text(
                String(
                  format: NSLocalizedString("%d x %d %dppi", bundle: .module, comment: ""),
                  display.widthInPixels, display.heightInPixels, display.pixelsPerInch
                )
              )
            }
          }
        }

        ForEach(self.specification.networkConfigurations) { _ in
          MachineSpecView(systemName: "network") {
            Text(.machineDetailsNetwork)
          } value: {
            Text(.machineDetailsNetworkNat)
          }
        }
      }
    }
  }

  struct MachineSpecListView_Previews: PreviewProvider {
    static var previews: some View {
      MachineSpecListView(
        specification: .preview,
        operatingSystem: .init(
          type: .macOS,
          version: .init(majorVersion: 12, minorVersion: 4, patchVersion: 0),
          buildVersion: "21G72"
        ),
        previewImageManager: VirtualizationImageManager()
      )
    }
  }
#endif
