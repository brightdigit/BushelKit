//
// ConfigurationView.swift
// Copyright (c) 2024 BrightDigit.
//

// swiftlint:disable file_length

#if canImport(SwiftUI)
  import BushelCore
  import BushelDataCore
  import BushelFactoryViews
  import BushelLocalization
  import BushelLogging
  import BushelMachine
  import BushelMachineEnvironment
  import BushelViewsCore
  import Observation
  import SwiftData
  import SwiftUI

  public struct ConfigurationView: View, Loggable {
    @Binding var buildRequest: MachineBuildRequest?
    @State var buildResult: Result<URL, BuilderError>?
    @State var object: ConfigurationObject

    @Environment(\.database) private var database
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openWindow) private var openWindow
    @Environment(\.metadataLabelProvider) private var metadataLabelProvider
    @Environment(\.machineSystemManager) private var systemManager

    var installerImageRepository: any InstallerImageRepository {
      self.machineRestoreImageDBFrom(database)
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
        Slider(
          value: self.$object.configuration.cpuCount,
          in: self.object.range.cpuCount,
          step: 1
        )
        .layoutPriority(100)
        TextField(
          value: self.$object.configuration.cpuCount,
          format: .number
        ) {
          Text(LocalizedStringID.machineDetailsMemoryName)
        }.frame(minWidth: 70, idealWidth: 75, maxWidth: 100).multilineTextAlignment(.trailing)
        Stepper(value: self.$object.configuration.cpuCount, in: self.object.range.cpuCount) {
          Text(.machineDetailsMemoryName)
        }
      }
    }

    public var memorySectionContent: some View {
      HStack {
        Slider(
          value: self.$object.configuration.memory,
          in: self.object.range.memory,
          step: 1 * 1024 * 1024 * 1024
        ).layoutPriority(100)

        Text(
          Int64(self.object.configuration.memory),
          format: .byteCount(style: .file)
        )
        .frame(minWidth: 70, idealWidth: 75, maxWidth: 100)
        .multilineTextAlignment(.trailing)
        .opacity(0.8)
        Stepper(
          value: self.$object.configuration.memory,
          in: self.object.range.memory,
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
            object.beginPrepareBuild(using: self.installerImageRepository)
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

    public var storage: some View {
      LabeledContent {
        HStack {
          Slider(
            value: self.$object.configuration.primaryStorageSizeFloat,
            in: (8 * 1024 * 1024 * 1024) ... (128 * 1024 * 1024 * 1024)
          )
          .layoutPriority(100)
          Text(
            Int64(self.object.configuration.primaryStorage.size),
            format: .byteCount(style: .file)
          )
          .frame(minWidth: 70, idealWidth: 75, maxWidth: 100)
          .multilineTextAlignment(.trailing)
          .opacity(0.8)
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
      }.labeledContentStyle(.vertical())
    }

    public var form: some View {
      Form {
        LabeledContent {
          LabeledContent {
            restoreImageSectionContent
          } label: {
            if let longName = self.object.restoreImageMetadata?.longName {
              VStack(alignment: .leading) {
                Text(.machineWillInstall)
                Text(longName).fontWeight(.bold)
              }
            }
          }.labeledContentStyle(.vertical())
        } label: {
          if let systemName = self.object.restoreImageMetadata?.systemName {
            Text(systemName)
          }
        }

        LabeledContent {
          LabeledContent {
            cpuSectionContent
          } label: {
            Text(.machineDetailsCPUCount)
          }.labeledContentStyle(.vertical())
        } label: {
          Text(.machineDetailsCPUName)
        }

        LabeledContent {
          LabeledContent {
            memorySectionContent
          } label: {
            Text(.machineDetailsMemorySize)
          }.labeledContentStyle(.vertical())
        } label: {
          Text(.machineDetailsMemoryName)
        }

        LabeledContent {
          VStack {
            LabeledContent {
              TextField(text: self.$object.configuration.primaryStorage.label) {
                Text(.name)
              }
            } label: {
              Text(.name)
            }.labeledContentStyle(.vertical())
            storage
          }
        } label: {
          Text(.machineDetailsStorageName)
        }

        .padding(.vertical, 8.0)
        formFooter
      }
    }

    public var body: some View {
      form
        .frame(width: 350)
        .padding()
        .background {
          self.listenForExport
        }
        .alert(
          isPresented: self.$object.isAlertPresented,
          error: self.object.error,
          actions: { _ in
            ConfigurationAlertActions(
              destinationURL: self.object.getDestinationURL(assertionFailureIfNil: true),
              onCompleted: self.dismissWindow
            )
          },
          message: { error in
            Text(error.alertMessageText)
            if self.object.getDestinationURL(assertionFailureIfNil: true) != nil {
              Text(.machineInstallErrorDelete)
            }
          }
        )

        .onChange(of: self.buildRequest, self.object.onBuildRequestChange(from:to:))
        .onChange(of: self.object.configuration.restoreImageID, self.object.onRestoreImageChange(from:to:))
        .onChange(of: self.buildResult) { _, newValue in
          guard let machineURL = self.object.machineURL(fromBuildResult: newValue) else {
            self.buildResult = nil
            return
          }
          self.openWindow(value: MachineFile(url: machineURL))
          self.dismissWindow()
        }
        .onAppear {
          self.object.beginSetupFrom(
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

    public func dismissWindow() {
      Task { @MainActor in
        self.dismiss()
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
