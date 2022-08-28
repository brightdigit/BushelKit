//
// BushelScene.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/28/22.
//

import BushelMachine
import BushelMachineMacOS
import SwiftUI

struct BushelScene: Scene {
  static let imageManagers = [
    VirtualizationImageManager.self
  ]
  let recentDocumentsObject = RecentDocumentsObject()

  init() {
    try! AnyImageManagers.load(Self.imageManagers)
  }

  var body: some Scene {
    attemptSingleWindowFor("Welcome to Bushel", id: "welcome") {
      WelcomeView().environmentObject(recentDocumentsObject).frame(width: 950, height: 450).presentedWindowStyle(.hiddenTitleBar).presentedWindowToolbarStyle(.unifiedCompact(showsTitle: false))
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
    }
    DocumentGroup(viewing: RestoreImageDocument.self) { file in
      RestoreImageDocumentView(document: file.document, manager: VirtualizationImageManager(), url: file.fileURL)
    }
    attemptSingleWindowFor("macOS Images", id: "rris-collection") {
      RrisCollectionView()
    }.windowsHandle(BasicWindowOpenHandle.remoteSources)
    WindowGroup {
      SessionView()
    }.windowsHandle(MachineSessionWindowHandle.self)
  }
}
