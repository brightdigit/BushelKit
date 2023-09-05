//
// ConfigurationView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelMachine
  import BushelViewsCore
  import Observation
  import SwiftData
  import SwiftUI

  public struct ConfigurationView: View {
    struct TextFieldButtonHeight: PreferenceKey {
      static let defaultValue: CGFloat = 0

      static func reduce(value: inout CGFloat,
                         nextValue: () -> CGFloat) {
        value = max(value, nextValue())
      }
    }

    @Binding var buildRequest: MachineBuildRequest?
    @State var buildResult: Result<URL, BuildError>?
    @State private var textFieldButtonHeight: CGFloat?
    @State var object: ConfigurationObject

    @Environment(\.modelContext) private var context
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openWindow) private var openWindow

    var installerImageRepository: InstallerImageRepository {
      self.machineRestoreImageDBFrom(context)
    }

    internal init(request: Binding<MachineBuildRequest?>, object: ConfigurationObject) {
      self._buildRequest = request
      self._object = .init(initialValue: object)
    }

    public var restoreImageSectionContent: some View {
      HStack {
        TextField(text: .constant(self.object.restoreImageMetadata?.shortName ?? "")) {
          Text("OS Name")
        }.background(GeometryReader { geometry in
          Color.clear.preference(
            key: TextFieldButtonHeight.self,
            value: geometry.size.height
          )
        }).disabled(true)

        Button(action: {
          self.object.presentImageSelection = true
        }, label: {
          Image.resource("UI/library").resizable().aspectRatio(contentMode: .fit).padding(4.0)
        }).buttonStyle(.borderless).frame(height: textFieldButtonHeight).padding(.vertical, -8.0)
      }
    }

    public var cpuSectionContent: some View {
      HStack {
        Slider(value: self.$object.configuration.cpuCount, in: 1 ... 4, step: 1).layoutPriority(100)
        TextField(
          value: self.$object.configuration.cpuCount,
          format: .number
        ) {
          Text(LocalizedStringID.machineDetailsMemory)
        }.frame(minWidth: 70, idealWidth: 75, maxWidth: 100).multilineTextAlignment(.trailing)
        Stepper(value: self.$object.configuration.cpuCount, in: 1 ... 4) {
          Text(LocalizedStringID.machineDetailsMemory)
        }
      }
    }

    public var memorySectionContent: some View {
      HStack {
        Slider(value: self.$object.configuration.memory, in: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024)).layoutPriority(100)
        TextField(
          value: self.$object.configuration.memory,
          formatter: ByteCountFormatter.memory
        ) {
          Text(LocalizedStringID.machineDetailsMemory)
        }.frame(minWidth: 70, idealWidth: 75, maxWidth: 100).multilineTextAlignment(.trailing)
        Stepper(value: self.$object.configuration.memory, in: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024), step: 1 * 1024 * 1024 * 1024) {
          Text(LocalizedStringID.machineDetailsMemory)
        }
      }
    }

    public var formFooter: some View {
      HStack {
        Spacer().layoutPriority(0)
        HStack {
          Button(role: .cancel) {
            dismiss()
          } label: {
            Text("Cancel").frame(minWidth: 0, maxWidth: .infinity)
          }.keyboardShortcut(.cancelAction).frame(minWidth: 0, maxWidth: .infinity)
          Button {
            object.prepareBuild(using: self.installerImageRepository)
          } label: {
            Text("Build").frame(minWidth: 0, maxWidth: .infinity)
          }
          .keyboardShortcut(.defaultAction)
          .frame(minWidth: 0, maxWidth: .infinity)
          .buttonStyle(BorderedProminentButtonStyle())
          .disabled(!self.object.isBuildable)
        }
      }
    }

    public var body: some View {
      Form {
        GroupLabeledContent {
          restoreImageSectionContent
        }
        group: {
          if let longName = self.object.restoreImageMetadata?.longName {
            VStack(alignment: .leading) {
              Text("This will install:")
              Text(longName).fontWeight(.bold)
            }
          }
        }
        label: {
          Text("macOS")
        }
        .onPreferenceChange(TextFieldButtonHeight.self) {
          textFieldButtonHeight = $0 + 8.0
        }

        GroupLabeledContent {
          cpuSectionContent
        } group: {
          Text("Count")
        } label: {
          Text("CPU")
        }.padding(.vertical, 8.0)

        GroupLabeledContent {
          memorySectionContent
        } group: {
          Text("Size")
        } label: {
          Text("Memory")
        }.padding(.vertical, 8.0)

        GroupLabeledContent {
          LabeledContent {
            TextField(text: self.$object.configuration.primaryStorage.label) {
              Text("Name")
            }
          } label: {
            Text("Name")
          }
          LabeledContent {
            HStack {
              Slider(value: self.$object.configuration.primaryStorageSizeFloat, in: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024)).layoutPriority(100)
              TextField(
                value: self.$object.configuration.primaryStorageSizeFloat,
                formatter: ByteCountFormatter.file
              ) {
                Text(LocalizedStringID.machineDetailsMemory)
              }.labelsHidden().frame(minWidth: 70, idealWidth: 75, maxWidth: 100).multilineTextAlignment(.trailing)
              Stepper(value: self.$object.configuration.primaryStorageSizeFloat, in: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024), step: 1 * 1024 * 1024 * 1024) {
                Text(LocalizedStringID.machineDetailsMemory)
              }
            }
          } label: {
            Text("Size")
          }
        } label: {
          Text("Storage")
        }

        .padding(.vertical, 8.0)
        formFooter
      }
      .frame(width: 350)
      .padding()
      .background(content: self.listenForExport)
      .onChange(of: self.buildRequest, self.object.onBuildRequestChange(from:to:))
      .onChange(of: self.object.configuration.restoreImageID, self.object.onRestoreImageChange(from:to:))
      .onChange(of: self.buildResult) { _, newValue in
        guard let machineURL = try? newValue?.get() else {
          return
        }
        self.openWindow(value: MachineFile(url: machineURL))
      }
      .onAppear {
        self.object.setupFrom(request: self.buildRequest, using: self.installerImageRepository)
      }
      .sheet(item: self.$object.builder) { builder in
        InstallerView(buildResult: self.$buildResult, builder: builder.builder)
      }
    }

    func listenForExport() -> some View {
      Group {
        if let machineConfiguration = object.machineConfiguration {
          Color.clear
            .fileExporter(
              isPresented: self.$object.presentFileExporter,
              document: CodablePackageDocument<MachineConfiguration>(configuration: machineConfiguration),
              defaultFilename: self.object.defaultFileName + ".bshvm",
              onCompletion: { result in
                self.object.beginBuildRequest(for: result, using: self.installerImageRepository)
              }
            )
        } else {
          Color.clear
        }
      }
    }
  }

  extension ConfigurationView {
    init(request: Binding<MachineBuildRequest?>) {
      let object = ConfigurationObject(configuration: .init(request: request.wrappedValue))
      self.init(request: request, object: object)
    }
  }

  // #Preview {
//  MachineSetupView()
  // }
#endif
