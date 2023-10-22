//
// ConfigurationView.swift
// Copyright (c) 2023 BrightDigit.
//

// swiftlint:disable file_length

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelMachine
  import BushelViewsCore
  import Observation
  import SwiftData
  import SwiftUI

  public struct ConfigurationView: View {
    @Binding var buildRequest: MachineBuildRequest?
    @State var buildResult: Result<URL, BuildError>?
    @State var object: ConfigurationObject

    @Environment(\.modelContext) private var context
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openWindow) private var openWindow
    @Environment(\.metadataLabelProvider) private var metadataLabelProvider
    @Environment(\.machineSystemManager) private var systemManager

    var installerImageRepository: InstallerImageRepository {
      self.machineRestoreImageDBFrom(context)
    }

    public var restoreImageSectionContent: some View {
      PreferredLayoutView { value in
        HStack {
          TextField(text: .constant(self.object.restoreImageMetadata?.shortName ?? "")) {
            Text(LocalizedStringID.machineDetailsOS)
          }
          .apply(\.size.height, with: value)
          .disabled(true)

          Button(action: {
            self.object.presentImageSelection = true
          }, label: {
            Image.resource("UI/library").resizable().aspectRatio(contentMode: .fit).padding(4.0)
          }).buttonStyle(.borderless).frame(height: value.get()).padding(.vertical, -8.0)
        }
      }
    }

    public var cpuSectionContent: some View {
      HStack {
        Slider(value: self.$object.configuration.cpuCount, in: 1 ... 4, step: 1).layoutPriority(100)
        TextField(
          value: self.$object.configuration.cpuCount,
          format: .number
        ) {
          Text(LocalizedStringID.machineDetailsMemoryName)
        }.frame(minWidth: 70, idealWidth: 75, maxWidth: 100).multilineTextAlignment(.trailing)
        Stepper(value: self.$object.configuration.cpuCount, in: 1 ... 4) {
          Text(.machineDetailsMemoryName)
        }
      }
    }

    public var memorySectionContent: some View {
      HStack {
        Slider(
          value: self.$object.configuration.memory,
          in: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024)
        ).layoutPriority(100)
        TextField(
          value: self.$object.configuration.memory,
          formatter: ByteCountFormatter.memory
        ) {
          Text(LocalizedStringID.machineDetailsMemoryName)
        }.frame(minWidth: 70, idealWidth: 75, maxWidth: 100).multilineTextAlignment(.trailing)
        Stepper(
          value: self.$object.configuration.memory,
          in: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024),
          step: 1 * 1024 * 1024 * 1024
        ) {
          Text(LocalizedStringID.machineDetailsMemoryName)
        }
      }
    }

    public var formFooter: some View {
      HStack {
        Spacer().layoutPriority(0)
        HStack {
          Button(
            role: .cancel
          ) {
            dismiss()
          } label: {
            Text(.cancel).frame(minWidth: 0, maxWidth: .infinity)
          }
          .keyboardShortcut(.cancelAction)
          .frame(minWidth: 0, maxWidth: .infinity)
          Button {
            object.prepareBuild(using: self.installerImageRepository)
          } label: {
            Text(.buildMachine).frame(minWidth: 0, maxWidth: .infinity)
          }
          .keyboardShortcut(.defaultAction)
          .frame(minWidth: 0, maxWidth: .infinity)
          .buttonStyle(BorderedProminentButtonStyle())
          .disabled(!self.object.isBuildable)
        }
      }
    }

    public var storage: LabeledContent<some View, some View> {
      LabeledContent {
        HStack {
          Slider(
            value: self.$object.configuration.primaryStorageSizeFloat,
            in: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024)
          )
          .layoutPriority(100)
          TextField(
            value: self.$object.configuration.primaryStorageSizeFloat,
            formatter: ByteCountFormatter.file
          ) {
            Text(LocalizedStringID.machineDetailsMemoryName)
          }
          .labelsHidden()
          .frame(minWidth: 70, idealWidth: 75, maxWidth: 100)
          .multilineTextAlignment(.trailing)
          Stepper(
            value: self.$object.configuration.primaryStorageSizeFloat,
            in: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024),
            step: 1 * 1024 * 1024 * 1024
          ) {
            Text(LocalizedStringID.machineDetailsMemoryName)
          }
        }
      } label: {
        Text(.machineDetailsStorageSize)
      }
    }

    public var form: some View {
      Form {
        GroupLabeledContent {
          restoreImageSectionContent
        }
        group: {
          if let longName = self.object.restoreImageMetadata?.longName {
            VStack(alignment: .leading) {
              Text(.machineWillInstall)
              Text(longName).fontWeight(.bold)
            }
          }
        }
        label: {
          if let systemName = self.object.restoreImageMetadata?.systemName {
            Text(systemName)
          }
        }

        GroupLabeledContent {
          cpuSectionContent
        } group: {
          Text(.machineDetailsCPUCount)
        } label: {
          Text(.machineDetailsCPUName)
        }.padding(.vertical, 8.0)

        GroupLabeledContent {
          memorySectionContent
        } group: {
          Text(.machineDetailsMemorySize)
        } label: {
          Text(.machineDetailsMemoryName)
        }.padding(.vertical, 8.0)

        GroupLabeledContent {
          LabeledContent {
            TextField(text: self.$object.configuration.primaryStorage.label) {
              Text(.name)
            }
          } label: {
            Text(.name)
          }
          storage
        } label: {
          Text(.machineDetailsStorageName)
        }

        .padding(.vertical, 8.0)
        formFooter
      }
    }

    #warning("logging-note: should we print result of onChange(of..)?")
    public var body: some View {
      form
        .frame(width: 350)
        .padding()
        .background {
          self.listenForExport
        }
        .onChange(of: self.buildRequest, self.object.onBuildRequestChange(from:to:))
        .onChange(of: self.object.configuration.restoreImageID, self.object.onRestoreImageChange(from:to:))
        .onChange(of: self.buildResult) { _, newValue in
          guard let machineURL = try? newValue?.get() else {
            #warning("logging-note: should we log here?")
            return
          }
          self.openWindow(value: MachineFile(url: machineURL))
          self.dismiss()
        }
        .onAppear {
          #warning("log some details about this setup, like details of buildRequest, systemManager, etc..")
          self.object.setupFrom(
            request: self.buildRequest,
            systemManager: self.systemManager,
            using: self.installerImageRepository,
            labelProvider: metadataLabelProvider.callAsFunction
          )
        }
        .sheet(item: self.$object.builder, content: { builder in
          InstallerView(buildResult: self.$buildResult, builder: builder.builder)
        })
        .sheet(isPresented: self.$object.presentImageSelection, content: {
          #warning("logging-note: should we log number of images somewhere?")
          ImageListSelectionView(
            selectedImageID: self.$object.sheetSelectedRestoreImageID,
            images: self.object.images
          )
          .frame(width: 500, height: 200)
        })
    }

    var listenForExport: some View {
      Group {
        if let machineConfiguration = object.machineConfiguration {
          Color.clear
            .fileExporter(
              isPresented: self.$object.presentFileExporter,
              document: CodablePackageDocument<MachineConfiguration>(configuration: machineConfiguration),
              defaultFilename: self.object.defaultFileName + ".bshvm",
              onCompletion: { result in
                #warning("we should start logging every single step from here till the end of it")
                self.object.beginBuildRequest(for: result, using: self.installerImageRepository)
              }
            )
        } else {
          Color.clear
        }
      }
    }

    internal init(request: Binding<MachineBuildRequest?>, object: ConfigurationObject) {
      self._buildRequest = request
      self._object = .init(initialValue: object)
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
