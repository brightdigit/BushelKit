//
// DialogView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelLogging
  import BushelMachine
  import BushelMachineEnvironment
  import BushelViewsCore
  import RadiantKit
  import SwiftData
  import SwiftUI

  @MainActor
  public struct DialogView: View, Loggable {
    private let system: VMSystemID
    @State private var windowInitialized = false
    @Binding private var buildRequest: MachineBuildRequest?
    @State private var object: BuildConfigurationObject
    @State private var buildResult: Result<URL, BuilderError>?

    @Environment(\.database) private var database
    @Environment(\.metadataLabelProvider) private var metadataLabelProvider
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom
    @Environment(\.releaseCollectionProvider) private var releaseCollectionProvider
    @Environment(\.dismiss) private var dismiss
    @Environment(\.machineSystemManager) private var systemManager
    @Environment(\.openWindow) private var openWindow

    #if os(macOS)
      @Environment(\.newLibrary) private var newLibrary
      @Environment(\.openLibrary) private var openLibrary
    #endif

    private var installerImageRepository: any InstallerImageRepository {
      self.machineRestoreImageDBFrom(database)
    }

    public var body: some View {
      PageView(
        onDismiss: { parameters in
          switch parameters.action {
          case .cancel:
            dismiss()
            return

          case .next:
            self.object.presentFileDialog()

          default:
            assert(parameters.action == .cancel)
          }
        }, {
          ContainerView {
            Text(.machineDialogChooseOS)
          } content: { isNextReady in
            Group {
              if let releasePrefix = object.releasePrefix {
                RestoreImageSelectorView(
                  releasePrefix: releasePrefix,
                  object: self.$object,
                  isNextReady: isNextReady
                )
              }
            }
          }
          ContainerView {
            Text(.machineDialogChooseSpecifications)
          } content: { isNextReady in
            Group {
              if let specification = Binding($object.specificationConfiguration) {
                SpecificationConfigurationView(isNextReady: isNextReady, configuration: specification)
              } else {
                EmptyView()
              }
            }
          }
        }
      )
      .background {
        self.listenForExport
      }
      .alert(isPresented: self.$object.isAlertPresented, error: self.object.error, actions: {
        ConfigurationAlertActions(
          destinationURL: self.object.getDestinationURL(assertionFailureIfNil: true),
          onCompleted: self.dismissWindow
        )
      })
      .alert(
        Text(.machineImagesEmptyTitle),
        isPresented: self.$object.promptForLibrary,
        actions: {
          #if os(macOS)
            Button {
              self.newLibrary(with: openWindow)
              self.dismissWindow()
            } label: {
              Text(.machineImagesEmptyNewLibrary)
            }
            Button {
              self.openLibrary(with: openWindow)
              self.dismissWindow()
            } label: {
              Text(.machineImagesEmptyAddLibrary)
            }
          #endif
          Button(
            role: .cancel
          ) {
            self.dismissWindow()
          } label: {
            Text(.cancel)
          }
        }, message: {
          Text(.machineImagesEmptyMessage)
        }
      )
      .nsWindowAdaptor(self.setupNSWindow)
      .onAppear {
        self.object.beginSetupWith(
          systemManager: systemManager,
          releaseCollectionProvider: releaseCollectionProvider.callAsFunction(_:),
          imageRepository: installerImageRepository,
          metadataLabelProvider: metadataLabelProvider.callAsFunction(_:_:)
        )
      }
      .sheet(item: self.$object.activeBuild, content: { build in
        InstallerView(
          buildResult: self.$buildResult,
          builder: build.builder
        )
      })
      .onChange(of: self.buildRequest, initial: true) { _, newValue in
        self.object.buildRequestChangedTo(newValue)
      }
      .onChange(of: self.buildResult) { _, newValue in
        guard let machineURL = self.object.machineURL(fromBuildResult: newValue) else {
          self.buildResult = nil
          return
        }
        self.openWindow(value: MachineFile(url: machineURL))
        #warning("fix auxilary file lock.")
        self.dismissWindow()
      }
    }

    private var listenForExport: some View {
      Group {
        if let machineConfiguration = object.machineConfiguration {
          Color.clear
            .fileExporter(
              isPresented: self.$object.presentFileExporter,
              document: CodablePackageDocument<MachineConfiguration>(configuration: machineConfiguration),
              defaultFilename: self.object.defaultFileName,
              onCompletion: {
                self.object.beginBuild(result: $0)
              }
            )
        } else {
          Color.clear
        }
      }
    }

    public init(system: VMSystemID, request: Binding<MachineBuildRequest?>) {
      self.system = system
      self._object = .init(
        wrappedValue: .init(
          system: system
        )
      )
      self._buildRequest = request
    }

    public func dismissWindow() {
      Task { @MainActor in
        self.dismiss()
      }
    }

    #if os(macOS)
      @MainActor
      private func setupNSWindow(_ window: NSWindow?) {
        guard let window, !windowInitialized else {
          return
        }
        window.isRestorable = false
        window.standardWindowButton(.closeButton)?.superview?.isHidden = true
        window.titlebarAppearsTransparent = true
        window.level = .floating
        windowInitialized = true
        Self.logger.debug("Completed Window Initialization.")
      }
    #else
      private func setupNSWindow(_: Any?) {}
    #endif
  }

//  #Preview {
//    DialogView(system: "preview", request: .constant(nil))
//  }
#endif
