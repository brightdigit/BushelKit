//
// BushelScene.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
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
    }.windowsHandle(.welcome).windowStyle(.hiddenTitleBar)
    DocumentGroup(newDocument: RestoreImageLibraryDocument()) { file in
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
            Windows.showNewDocumentWindow(ofType: .restoreImageLibrary)
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
      // https://stackoverflow.com/questions/67659770/how-to-read-large-files-using-swiftui-documentgroup-without-making-a-temporary-c
      RestoreImageDocumentView(document: file.document, manager: VirtualizationImageManager(), url: file.fileURL)
    }
    WindowGroup {
      RrisCollectionView()
    }.windowsHandle(.remoteSources)
  }
}
