//
// MachineSetupView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelReactive
  import BushelVirtualization
  import SwiftUI

  struct MachineSpecificationTemplate: Identifiable {
    let id: String
    let systemImageName: String
    let label: String

    static let items: [MachineSpecificationTemplate] = [
      .init(id: "macpro.gen3.fill", systemImageName: "macpro.gen3.fill", label: "Mac Pro (2019)"),

      .init(id: "macmini.fill", systemImageName: "macmini.fill", label: "Mac Mini (2020)"),

      .init(id: "macstudio.fill", systemImageName: "macstudio.fill", label: "Mac Studio (2022)"),

      .init(id: "macbookair.2020", systemImageName: "laptopcomputer", label: "Mac Book Air (2020)"),
      .init(id: "macbookair.2022", systemImageName: "laptopcomputer", label: "Mac Book Air (2022)"),

      .init(id: "macbookpro.2021", systemImageName: "laptopcomputer", label: "MacBook Pro (2021)"),
      .init(id: "macbookpro.2022", systemImageName: "laptopcomputer", label: "MacBook Pro (2022)"),
      .init(id: "", systemImageName: "gear.badge.questionmark", label: "Custom")
    ]
  }

  struct MachineSetupView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    @Binding var machineRestoreImageID: UUID

    @State var machineSavedURL: URL?
    @State var machine: Machine
    @State var disks: [MachineStorageSpecification] = [.init(label: "macOS System", size: UInt64(64 * 1024 * 1024 * 1024))]
    @State var cpuCount: Float = 1
    @State var memory: Float = (128 * 1024 * 1024 * 1024)
    @State var selectedDisplayResolution: GraphicsDisplay = {
      let resolution = Self.displayConfigurations.first(where: {
        $0.widthInPixels == 1920 && $0.heightInPixels == 1080
      })!

      return resolution
    }()

    @EnvironmentObject var appContext: ApplicationContext
    @StateObject var installationObject = MachineInstallationObject()

    static let memoryFormatter: ByteCountFormatter = {
      let formatter = ByteCountFormatter()
      formatter.countStyle = .memory
      return formatter
    }()

    static let displayConfigurations: [GraphicsDisplay] = [
      .init(widthInPixels: 480, heightInPixels: 320, pixelsPerInch: 80),
      .init(widthInPixels: 640, heightInPixels: 240, pixelsPerInch: 80),
      .init(widthInPixels: 640, heightInPixels: 240, pixelsPerInch: 80),
      .init(widthInPixels: 640, heightInPixels: 256, pixelsPerInch: 80),
      .init(widthInPixels: 512, heightInPixels: 342, pixelsPerInch: 80),
      .init(widthInPixels: 368, heightInPixels: 480, pixelsPerInch: 80),
      .init(widthInPixels: 496, heightInPixels: 384, pixelsPerInch: 80),
      .init(widthInPixels: 800, heightInPixels: 240, pixelsPerInch: 80),
      .init(widthInPixels: 512, heightInPixels: 384, pixelsPerInch: 80),
      .init(widthInPixels: 640, heightInPixels: 320, pixelsPerInch: 80),
      .init(widthInPixels: 640, heightInPixels: 350, pixelsPerInch: 80),
      .init(widthInPixels: 640, heightInPixels: 360, pixelsPerInch: 80),
      .init(widthInPixels: 480, heightInPixels: 500, pixelsPerInch: 80),
      .init(widthInPixels: 512, heightInPixels: 480, pixelsPerInch: 80),
      .init(widthInPixels: 720, heightInPixels: 348, pixelsPerInch: 80),
      .init(widthInPixels: 720, heightInPixels: 350, pixelsPerInch: 80),
      .init(widthInPixels: 640, heightInPixels: 400, pixelsPerInch: 80),
      .init(widthInPixels: 720, heightInPixels: 364, pixelsPerInch: 80),
      .init(widthInPixels: 800, heightInPixels: 352, pixelsPerInch: 80),
      .init(widthInPixels: 600, heightInPixels: 480, pixelsPerInch: 80),
      .init(widthInPixels: 640, heightInPixels: 480, pixelsPerInch: 80),
      .init(widthInPixels: 640, heightInPixels: 512, pixelsPerInch: 80),
      .init(widthInPixels: 768, heightInPixels: 480, pixelsPerInch: 80),
      .init(widthInPixels: 800, heightInPixels: 480, pixelsPerInch: 80),
      .init(widthInPixels: 848, heightInPixels: 480, pixelsPerInch: 80),
      .init(widthInPixels: 854, heightInPixels: 480, pixelsPerInch: 80),
      .init(widthInPixels: 800, heightInPixels: 600, pixelsPerInch: 80),
      .init(widthInPixels: 960, heightInPixels: 540, pixelsPerInch: 80),
      .init(widthInPixels: 832, heightInPixels: 624, pixelsPerInch: 80),
      .init(widthInPixels: 960, heightInPixels: 544, pixelsPerInch: 80),
      .init(widthInPixels: 1024, heightInPixels: 576, pixelsPerInch: 80),
      .init(widthInPixels: 960, heightInPixels: 640, pixelsPerInch: 80),
      .init(widthInPixels: 1024, heightInPixels: 600, pixelsPerInch: 80),
      .init(widthInPixels: 1024, heightInPixels: 640, pixelsPerInch: 80),
      .init(widthInPixels: 960, heightInPixels: 720, pixelsPerInch: 80),
      .init(widthInPixels: 1136, heightInPixels: 640, pixelsPerInch: 80),
      .init(widthInPixels: 1138, heightInPixels: 640, pixelsPerInch: 80),
      .init(widthInPixels: 1024, heightInPixels: 768, pixelsPerInch: 80),
      .init(widthInPixels: 1024, heightInPixels: 800, pixelsPerInch: 80),
      .init(widthInPixels: 1152, heightInPixels: 720, pixelsPerInch: 80),
      .init(widthInPixels: 1152, heightInPixels: 768, pixelsPerInch: 80),
      .init(widthInPixels: 1280, heightInPixels: 720, pixelsPerInch: 80),
      .init(widthInPixels: 1120, heightInPixels: 832, pixelsPerInch: 80),
      .init(widthInPixels: 1280, heightInPixels: 768, pixelsPerInch: 80),
      .init(widthInPixels: 1152, heightInPixels: 864, pixelsPerInch: 80),
      .init(widthInPixels: 1334, heightInPixels: 750, pixelsPerInch: 80),
      .init(widthInPixels: 1280, heightInPixels: 800, pixelsPerInch: 80),
      .init(widthInPixels: 1152, heightInPixels: 900, pixelsPerInch: 80),
      .init(widthInPixels: 1024, heightInPixels: 1024, pixelsPerInch: 80),
      .init(widthInPixels: 1366, heightInPixels: 768, pixelsPerInch: 80),
      .init(widthInPixels: 1280, heightInPixels: 854, pixelsPerInch: 80),
      .init(widthInPixels: 1280, heightInPixels: 960, pixelsPerInch: 80),
      .init(widthInPixels: 1600, heightInPixels: 768, pixelsPerInch: 80),
      .init(widthInPixels: 1080, heightInPixels: 1200, pixelsPerInch: 80),
      .init(widthInPixels: 1440, heightInPixels: 900, pixelsPerInch: 80),
      .init(widthInPixels: 1440, heightInPixels: 900, pixelsPerInch: 80),
      .init(widthInPixels: 1280, heightInPixels: 1024, pixelsPerInch: 80),
      .init(widthInPixels: 1440, heightInPixels: 960, pixelsPerInch: 80),
      .init(widthInPixels: 1600, heightInPixels: 900, pixelsPerInch: 80),
      .init(widthInPixels: 1400, heightInPixels: 1050, pixelsPerInch: 80),
      .init(widthInPixels: 1440, heightInPixels: 1024, pixelsPerInch: 80),
      .init(widthInPixels: 1440, heightInPixels: 1080, pixelsPerInch: 80),
      .init(widthInPixels: 1600, heightInPixels: 1024, pixelsPerInch: 80),
      .init(widthInPixels: 1680, heightInPixels: 1050, pixelsPerInch: 80),
      .init(widthInPixels: 1776, heightInPixels: 1000, pixelsPerInch: 80),
      .init(widthInPixels: 1600, heightInPixels: 1200, pixelsPerInch: 80),
      .init(widthInPixels: 1600, heightInPixels: 1280, pixelsPerInch: 80),
      .init(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80),
      .init(widthInPixels: 1440, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 2048, heightInPixels: 1080, pixelsPerInch: 80),
      .init(widthInPixels: 1920, heightInPixels: 1200, pixelsPerInch: 80),
      .init(widthInPixels: 2048, heightInPixels: 1152, pixelsPerInch: 80),
      .init(widthInPixels: 1792, heightInPixels: 1344, pixelsPerInch: 80),
      .init(widthInPixels: 1920, heightInPixels: 1280, pixelsPerInch: 80),
      .init(widthInPixels: 2280, heightInPixels: 1080, pixelsPerInch: 80),
      .init(widthInPixels: 2340, heightInPixels: 1080, pixelsPerInch: 80),
      .init(widthInPixels: 1856, heightInPixels: 1392, pixelsPerInch: 80),
      .init(widthInPixels: 2400, heightInPixels: 1080, pixelsPerInch: 80),
      .init(widthInPixels: 1800, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 2880, heightInPixels: 900, pixelsPerInch: 80),
      .init(widthInPixels: 2160, heightInPixels: 1200, pixelsPerInch: 80),
      .init(widthInPixels: 2048, heightInPixels: 1280, pixelsPerInch: 80),
      .init(widthInPixels: 1920, heightInPixels: 1400, pixelsPerInch: 80),
      .init(widthInPixels: 2520, heightInPixels: 1080, pixelsPerInch: 80),
      .init(widthInPixels: 2436, heightInPixels: 1125, pixelsPerInch: 80),
      .init(widthInPixels: 2538, heightInPixels: 1080, pixelsPerInch: 80),
      .init(widthInPixels: 1920, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 2560, heightInPixels: 1080, pixelsPerInch: 80),
      .init(widthInPixels: 2160, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 2048, heightInPixels: 1536, pixelsPerInch: 80),
      .init(widthInPixels: 2304, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 2256, heightInPixels: 1504, pixelsPerInch: 80),
      .init(widthInPixels: 2560, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 2304, heightInPixels: 1728, pixelsPerInch: 80),
      .init(widthInPixels: 2560, heightInPixels: 1600, pixelsPerInch: 80),
      .init(widthInPixels: 2880, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 2960, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 2560, heightInPixels: 1700, pixelsPerInch: 80),
      .init(widthInPixels: 2560, heightInPixels: 1800, pixelsPerInch: 80),
      .init(widthInPixels: 2880, heightInPixels: 1620, pixelsPerInch: 80),
      .init(widthInPixels: 2560, heightInPixels: 1920, pixelsPerInch: 80),
      .init(widthInPixels: 3440, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 2736, heightInPixels: 1824, pixelsPerInch: 80),
      .init(widthInPixels: 2880, heightInPixels: 1800, pixelsPerInch: 80),
      .init(widthInPixels: 2560, heightInPixels: 2048, pixelsPerInch: 80),
      .init(widthInPixels: 2732, heightInPixels: 2048, pixelsPerInch: 80),
      .init(widthInPixels: 3200, heightInPixels: 1800, pixelsPerInch: 80),
      .init(widthInPixels: 2800, heightInPixels: 2100, pixelsPerInch: 80),
      .init(widthInPixels: 3072, heightInPixels: 1920, pixelsPerInch: 80),
      .init(widthInPixels: 3000, heightInPixels: 2000, pixelsPerInch: 80),
      .init(widthInPixels: 3840, heightInPixels: 1600, pixelsPerInch: 80),
      .init(widthInPixels: 3200, heightInPixels: 2048, pixelsPerInch: 80),
      .init(widthInPixels: 3240, heightInPixels: 2160, pixelsPerInch: 80),
      .init(widthInPixels: 5120, heightInPixels: 1440, pixelsPerInch: 80),
      .init(widthInPixels: 3200, heightInPixels: 2400, pixelsPerInch: 80),
      .init(widthInPixels: 3840, heightInPixels: 2160, pixelsPerInch: 80),
      .init(widthInPixels: 4096, heightInPixels: 2160, pixelsPerInch: 80),
      .init(widthInPixels: 3840, heightInPixels: 2400, pixelsPerInch: 80),
      .init(widthInPixels: 4096, heightInPixels: 2304, pixelsPerInch: 80),
      .init(widthInPixels: 5120, heightInPixels: 2160, pixelsPerInch: 80),
      .init(widthInPixels: 4480, heightInPixels: 2520, pixelsPerInch: 80),
      .init(widthInPixels: 4096, heightInPixels: 3072, pixelsPerInch: 80),
      .init(widthInPixels: 4500, heightInPixels: 3000, pixelsPerInch: 80),
      .init(widthInPixels: 5120, heightInPixels: 2880, pixelsPerInch: 80),
      .init(widthInPixels: 5120, heightInPixels: 3200, pixelsPerInch: 80),
      .init(widthInPixels: 5120, heightInPixels: 4096, pixelsPerInch: 80),
      .init(widthInPixels: 6016, heightInPixels: 3384, pixelsPerInch: 80),
      .init(widthInPixels: 6400, heightInPixels: 4096, pixelsPerInch: 80),
      .init(widthInPixels: 6400, heightInPixels: 4800, pixelsPerInch: 80),
      .init(widthInPixels: 6480, heightInPixels: 3240, pixelsPerInch: 80),
      .init(widthInPixels: 7680, heightInPixels: 4320, pixelsPerInch: 80),
      .init(widthInPixels: 7680, heightInPixels: 4800, pixelsPerInch: 80),
      .init(widthInPixels: 8192, heightInPixels: 4320, pixelsPerInch: 80),
      .init(widthInPixels: 8192, heightInPixels: 4608, pixelsPerInch: 80),
      .init(widthInPixels: 10240, heightInPixels: 4320, pixelsPerInch: 80),
      .init(widthInPixels: 8192, heightInPixels: 8192, pixelsPerInch: 80),
      .init(widthInPixels: 15360, heightInPixels: 8640, pixelsPerInch: 80)
    ]

    let onCompleted: ((Error?) -> Void)?

    var restoreImageChoices: [RestoreImageContextChoice]? {
//      guard
//        machine.operatingSystem == nil,
//        machineRestoreImageID != RestoreImageContextChoice.none.id else {
//        return nil
//      }
      let choices = appContext.images.map(
        RestoreImageContextChoice.init
      )
      let preselectedChoice = choices.first(where: {
        $0.id == machineRestoreImageID
      })
      if let preselectedChoice {
        return [preselectedChoice]
      }
      guard choices.isEmpty else {
        return nil
      }
      return choices
    }

    var selectedRestoreImageFile: RestoreImageLibraryItemFile? {
      let restoreImageChoice = restoreImageChoices?.first { $0.id == self.machineRestoreImageID
      }

      guard let restoreImage = restoreImageChoice?.machineRestoreImage?.image else {
        return nil
      }

      return RestoreImageLibraryItemFile(loadFromImage: restoreImage)
    }

    var buttons: some View {
      HStack {
        Button {
          dismiss()
        } label: {
          Text(.cancel)
        }
        Button {
          guard let selectedRestoreImageFile = selectedRestoreImageFile else {
            return
          }
          self.machine.restoreImage = selectedRestoreImageFile
          let savePanel = NSSavePanel()
          savePanel.nameFieldLabel = "Save Restore Image as:"

          savePanel.allowedContentTypes = [.virtualMachine]
          savePanel.isExtensionHidden = true

          savePanel.begin { response in
            guard let fileURL = savePanel.url, response == .OK else {
              return
            }

            let dataURL = fileURL.appendingPathComponent(Paths.machineDataDirectoryName)
            Task {
              let factory: VirtualMachineFactory
              do {
                factory = try await machine.build()
              } catch {
                Self.logger.error("failure building machine: \(error.localizedDescription)")
                return
              }
              installationObject.setupInstaller(factory)
              factory.beginBuild(at: dataURL)
            }
            self.machineSavedURL = fileURL
          }
        } label: {
          Text(.buildMachine)
        }
      }
    }

    fileprivate func deviceSelection() -> HStack<TupleView<(LazyHGrid<ForEach<[MachineSpecificationTemplate], String, some View>>, Divider, some View)>> {
      HStack {
        LazyHGrid(rows: [
          .init(.flexible(minimum: 160)),
          .init(.flexible(minimum: 160))
        ]) {
          ForEach(MachineSpecificationTemplate.items) { template in
            Button {} label: {
              VStack {
                Spacer()
                Image(systemName: template.systemImageName).resizable().aspectRatio(contentMode: .fit)
                Spacer()
                Text(template.label)
              }.padding()
            }.buttonStyle(.plain).frame(width: 160.0)
          }
        }
        Divider()
        Form {
          Text("Mac Studio 2022")

          Section("Chip") {
            Text("10 to 20 CPUs")
            VStack(alignment: .leading) {
              Text("10-core CPU with 8 performance cores and 2 efficiency cores").font(.caption).italic()
              Text("Configurable to:").font(.caption2).italic()
              Text("M1 Ultra with 20-core CPU, 64-core GPU, and 32-core Neural Engine").font(.caption).italic()
            }.padding(.leading)
          }

          Section("Memory") {
            Text("32 to 128 GBs")
            VStack(alignment: .leading) {
              Text("32GB unified memory").font(.caption).italic()
              Text("Configurable to:").font(.caption2).italic()
              Text("128GB unified memory").font(.caption).italic()
            }.padding(.leading)
          }
          Section("Storage") {
            Text("512 GB to 8 TBs")
            VStack(alignment: .leading) {
              Text("512GB SSD").font(.caption).italic()
              Text("Configurable to:").font(.caption2).italic()
              Text("8TB").font(.caption).italic()
            }.padding(.leading)
          }
          Spacer()
          Section {
            Button {} label: {
              Image(systemName: "arrow.down.to.line.circle.fill")
              Text("Apply")
            }
          }
        }.frame(width: 160)
      }
    }

    fileprivate func hardwardSetup() -> some View {
      VStack {
        HStack {
          Label("CPU", systemImage: "cpu.fill")
          Spacer()
          TextField("CPU", value: self.$cpuCount, formatter: NumberFormatter(), prompt: Text("CPU Count")).frame(maxWidth: 80)
          Slider(value: self.$cpuCount)
        }
        HStack {
          Label("Memory", systemImage: "internaldrive.fill")
          Spacer()

          TextField("Memory", value: self.$memory, formatter: Self.memoryFormatter, prompt: Text("Memory")).frame(maxWidth: 80)
          Slider(value: self.$memory)
        }
        HStack {
          Picker(selection: self.$selectedDisplayResolution) {
            ForEach(Self.displayConfigurations) { config in
              Text("\(config.description)")
            }
          } label: {
            Label("Display", systemImage: "display")
          }
        }
        HStack(alignment: .top) {
          Label("Disks", systemImage: "internaldrive.fill")
          Spacer()
          VStack(alignment: .leading) {
            List {
              ForEach(self.disks) { disk in
                HStack {
                  Image(systemName: "internaldrive.fill")
                  Text(disk.label)
                  Text(ByteCountFormatStyle.FormatInput(disk.size), format: .byteCount(style: .file))
                }
              }
            }.frame(minHeight: 100)
            HStack {
              Button {} label: {
                Image(systemName: "plus")
              }

              Button {} label: {
                Image(systemName: "minus")
              }
            }
          }
        }
      }.padding(.horizontal)
    }

    var body: some View {
      VStack {
        // deviceSelection()
        // Divider().padding(.horizontal)
        if let restoreImageChoices = self.restoreImageChoices {
          Picker("Restore Image", selection: self.$machineRestoreImageID) {
            ForEach(restoreImageChoices) { choice in
              Text(choice.name ?? "No Restore Image Available").tag(choice.id)
            }
          }.padding([.top, .horizontal])
        }
        // hardwardSetup()

        buttons.padding(.bottom).onReceive(self.installationObject.$phaseProgress, perform: { phase in
          guard case let .savedAt(result) = phase?.phase else {
            return
          }
          switch result {
          case let .success(machineConfigurationURL):
            #warning("Swap for MainActor")
            DispatchQueue.main.async {
              self.machine.installationCompletedAt(machineConfigurationURL)

              guard let machineSavedURL = self.machineSavedURL else {
                Self.logger.error("missing machine url")

                return
              }
              let machineURL = machineSavedURL.appendingPathComponent(Paths.machineJSONFileName)
              do {
                try Configuration.JSON.encoder.encode(self.machine).write(to: machineURL)
              } catch {
                Self.logger.error("unable to save machine at: \(error.localizedDescription)")
              }
              self.installationObject.cancel()

              Windows.openDocumentAtURL(machineSavedURL)
              self.dismiss()
            }

          case let .failure(error):
            #warning("Swap for MainActor")
            DispatchQueue.main.async {
              self.installationObject.cancel()
            }
            self.onCompleted?(error)
          }
        })

          .onAppear {
            dump(appContext.images)
            print(machine.restoreImage?.id)
            print(machine.restoreImage?.id)
            let restoreImageID = machine.restoreImage?.id ?? self.restoreImageChoices?.first?.id
            guard let restoreImageID = restoreImageID else {
              return
            }
            #warning("Swap for MainActor")
            DispatchQueue.main.async {
              self.machineRestoreImageID = restoreImageID
            }
          }

          .sheet(
            item: self.$installationObject.phaseProgress,
            content: { phase in
              MachineFactoryView(phaseProgress: phase, onCancel: self.buildingCancelled)
            }
          )
      }
    }

    internal init(
      machineRestoreImageID: Binding<UUID>,
      initialMachine: Machine = .init(),
      machineSavedURL: URL? = nil,
      onCompleted: ((Error?) -> Void)? = nil
    ) {
      _machineRestoreImageID = machineRestoreImageID
      _machine = .init(initialValue: initialMachine)
      self.onCompleted = onCompleted
      self.machineSavedURL = machineSavedURL
    }

    func buildingCancelled() {
      #warning("Swap for MainActor")
      DispatchQueue.main.async {
        self.installationObject.cancel()
      }
    }
  }

  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      MachineSetupView(
        machineRestoreImageID: .constant(UUID()),
        initialMachine: .init(specification: MockImageManager().defaultSpecifications()),
        onCompleted: nil
      ).onAppear {
        try! AnyImageManagers.load([MockImageManager.self])
      }.environmentObject(ApplicationContext(isPreview: true))
    }
  }
#endif
