//
// BushelScene.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelMachineMacOS
  import BushelVirtualization
  import SwiftUI

  struct BushelScene: Scene {
    #if canImport(Virtualization) && arch(arm64)
      static let imageManagers: [AnyImageManager.Type] = [VirtualizationImageManager.self]
    #else
      static let imageManagers: [AnyImageManager.Type] = []
    #endif

    @Environment(\.openURL) private var openURL: OpenURLAction
    let applicationContext = ApplicationContext()

    var body: some Scene {
      WindowGroup {
        WelcomeView()
          .environmentObject(applicationContext)
          .frame(width: 950, height: 450)
          .presentedWindowStyle(.hiddenTitleBar)
          .presentedWindowToolbarStyle(.unifiedCompact(showsTitle: false))
      }
      .windowsHandle(BasicWindowOpenHandle.welcome)
      .windowStyle(.hiddenTitleBar)
      .disableResizability()
      DocumentGroup(viewing: RestoreImageLibraryDocument.self) { file in
        RestoreImageLibraryDocumentView(
          document: file.document,
          url: file.fileURL
        ).environmentObject(applicationContext)
      }
      DocumentGroup(viewing: MachineDocument.self) { configuration in
        MachineView(document: configuration.$document, url: configuration.fileURL)
      }.commands {
        CommandGroup(replacing: .newItem) {
          Menu(.menuNew) {
            Button(.menuNewMachine) {
              Windows.openWindow(withHandle: MachineSetupWindowHandle(restoreImagePath: nil))
            }
            Button(.menuNewImageLibrary) {
              Windows.showNewSavedDocumentWindow(ofType: RestoreImageLibraryDocument.self)
            }
          }
        }
        CommandGroup(after: .newItem) {
          Button(.menuOpen) {
            let openPanel = NSOpenPanel()
            openPanel.allowedContentTypes = [.restoreImageLibrary, .bshvm, .virtualMachine]
            openPanel.isExtensionHidden = true
            openPanel.begin { response in
              guard let fileURL = openPanel.url, response == .OK else {
                return
              }
              Windows.openDocumentAtURL(fileURL)
            }
          }
          Menu(.menuOpenRecent) {
            RecentDocumentsMenuContent().environmentObject(applicationContext)
          }
          Divider()
          Button(.menuNewDownloadRestoreImage) {
            Windows.openWindow(withHandle: BasicWindowOpenHandle.remoteSources)
          }
        }
        CommandGroup(after: .windowArrangement) {
          Button(.menuWindowWelcomeToBushel) {
            Windows.openWindow(withHandle: BasicWindowOpenHandle.welcome)
          }
        }
        CommandGroup(replacing: .help) {
          Button(.menuHelpBushel) {
            openURL(Configuration.URLs.support)
          }
        }
      }
      #if canImport(Virtualization) && arch(arm64)
        DocumentGroup(viewing: RestoreImageDocument.self) { file in
          RestoreImageDocumentView(
            document: file.document,
            manager: VirtualizationImageManager(),
            url: file.fileURL
          )
        }
      #endif
      WindowGroup(Text(.remoteRestoreImages), id: "remote_restore_images") {
        RrisCollectionView()
      }.windowsHandle(BasicWindowOpenHandle.remoteSources)
      WindowGroup(id: MachineSetupWindowHandle.host) {
        if let id = applicationContext.images.randomElement()?.id {
          NewMachineView(machineRestoreImageID: id).environmentObject(applicationContext)
        } else {
          EmptyView()
        }
      }.windowsHandle(MachineSetupWindowHandle.self)
      WindowGroup(id: SnapshotRestorationWindowHandle.host) {
        SnapshotRestorationView()
      }.windowsHandle(SnapshotRestorationWindowHandle.self).windowStyle(.hiddenTitleBar)
        .disableResizability()
      WindowGroup(id: MachineSessionWindowHandle.host) {
        SessionView()
          .onReceive(
            NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification),
            perform: { _ in
              self.hideMiniButton()
            }
          )
          .presentedWindowStyle(.hiddenTitleBar)
          .presentedWindowToolbarStyle(.unifiedCompact(showsTitle: false))
      }
      .windowsHandle(MachineSessionWindowHandle.self).windowStyle(.hiddenTitleBar)
      Group {
        Settings {
          SettingsView()
        }
        WindowGroup {
          OnboardingView()
        }.windowsHandle(BasicWindowOpenHandle.onboarding)
        WindowGroup {
          PurchaseView()
        }.windowsHandle(BasicWindowOpenHandle.purchase)
      }
    }

    init() {
      // swiftlint:disable:next force_try
      try! AnyImageManagers.load(Self.imageManagers)
    }

    #warning("move to func on view")
    func hideMiniButton() {
      for window in NSApplication.shared.windows
        where window.identifier?.rawValue.hasPrefix(MachineSessionWindowHandle.host) == true {
        window.standardWindowButton(NSWindow.ButtonType.closeButton)?.isEnabled = false
      }
    }
  }
#endif
