//
// BushelScene.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/10/22.
//

import BushelMachine
import BushelMachineMacOS
import SwiftUI

public struct BushelScene: Scene {
  static let imageManagers = [
    VirtualizationImageManager.self
  ]

  init() {
    try! AnyImageManagers.load(Self.imageManagers)
  }

  public var body: some Scene {
    WindowGroup {
      WelcomeView()
    }.windowsHandle(BasicWindowOpenHandle.welcome).windowStyle(.hiddenTitleBar)
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
          RecentDocumentsMenuContent()
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
    WindowGroup(Text("Remote Restore Images"), id: "Remote Restore Images") {
      RrisCollectionView()
    }.windowsHandle(BasicWindowOpenHandle.remoteSources)
    WindowGroup {
      SessionView()
    }.windowsHandle(MachineSessionWindowHandle.self)
  }
}
