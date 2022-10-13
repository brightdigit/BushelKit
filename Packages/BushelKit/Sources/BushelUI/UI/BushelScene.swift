//
// BushelScene.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelMachineMacOS
  import SwiftUI

  struct BushelScene: Scene {
    @Environment(\.openURL) private var openURL: OpenURLAction

    #if canImport(Virtualization) && arch(arm64)
      static let imageManagers: [AnyImageManager.Type] = [VirtualizationImageManager.self]
    #else
      static let imageManagers: [AnyImageManager.Type] = []
    #endif
    let applicationContext = ApplicationContext()

    init() {
      // swiftlint:disable:next force_try
      try! AnyImageManagers.load(Self.imageManagers)
    }

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
      DocumentGroup(newDocument: MachineDocument()) { file in
        MachineView(document: file.$document, url: file.fileURL).environmentObject(applicationContext)
      }.commands {
        CommandGroup(replacing: .newItem) {
          Menu(.menuNew) {
            Button(.menuNewMachine) {
              Windows.showNewDocumentWindow(ofType: .virtualMachine)
            }
            Button(.menuNewImageLibrary) {
              Windows.showNewSavedDocumentWindow(ofType: RestoreImageLibraryDocument.self)
            }
          }
          Menu(.menuOpenRecent) {
            RecentDocumentsMenuContent().environmentObject(applicationContext)
          }
        }
        CommandGroup(after: .newItem) {
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
        NewMachineView().environmentObject(applicationContext)
      }.windowsHandle(MachineSetupWindowHandle.self)
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

    func hideMiniButton() {
      for window in NSApplication.shared.windows
        where window.identifier?.rawValue.hasPrefix(MachineSessionWindowHandle.host) == true {
        window.standardWindowButton(NSWindow.ButtonType.closeButton)?.isEnabled = false
      }
    }
  }
#endif
