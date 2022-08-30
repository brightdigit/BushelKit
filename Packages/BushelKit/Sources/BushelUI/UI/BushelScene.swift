//
// BushelScene.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine
import BushelMachineMacOS
import SwiftUI

struct BushelScene: Scene {
  @Environment(\.openURL) private var openURL: OpenURLAction

  static let imageManagers = [
    VirtualizationImageManager.self
  ]
  let recentDocumentsObject = RecentDocumentsObject()

  init() {
    // swiftlint:disable:next force_try
    try! AnyImageManagers.load(Self.imageManagers)
  }

  var body: some Scene {
    WindowGroup {
      WelcomeView()
        .environmentObject(recentDocumentsObject)
        .frame(width: 950, height: 450)
        .presentedWindowStyle(.hiddenTitleBar)
        .presentedWindowToolbarStyle(.unifiedCompact(showsTitle: false))
    }.windowsHandle(BasicWindowOpenHandle.welcome).windowStyle(.hiddenTitleBar).disableResizability()
    DocumentGroup(viewing: RestoreImageLibraryDocument.self) { file in
      RestoreImageLibraryDocumentView(document: file.$document, url: file.fileURL)
    }
    DocumentGroup(newDocument: MachineDocument()) { file in
      MachineView(document: file.$document, url: file.fileURL, restoreImageChoices: [])
    }.commands {
      CommandGroup(replacing: .newItem) {
        Menu("New") {
          Button("New Machine") {
            Windows.showNewDocumentWindow(ofType: .virtualMachine)
          }
          Button("New Image Library") {
            Windows.showNewSavedDocumentWindow(ofType: RestoreImageLibraryDocument.self)
          }
        }
        Menu("Open Recent") {
          RecentDocumentsMenuContent().environmentObject(recentDocumentsObject)
        }
      }
      CommandGroup(after: .newItem) {
        Button("Download Restore Image...") {
          Windows.openWindow(withHandle: BasicWindowOpenHandle.remoteSources)
        }
      }
      CommandGroup(after: .windowArrangement) {
        Button("Welcome to Bushel") {
          Windows.openWindow(withHandle: BasicWindowOpenHandle.welcome)
        }
      }
      CommandGroup(replacing: .help) {
        Button("Bushel Help") {
          openURL(Configuration.URLs.help)
        }
      }
    }
    DocumentGroup(viewing: RestoreImageDocument.self) { file in
      RestoreImageDocumentView(document: file.document, manager: VirtualizationImageManager(), url: file.fileURL)
    }
    WindowGroup(Text("Remote Restore Images"), id: "Remote Restore Images") {
      RrisCollectionView()
    }.windowsHandle(BasicWindowOpenHandle.remoteSources)
    WindowGroup {
      SessionView()
    }.windowsHandle(MachineSessionWindowHandle.self)
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
