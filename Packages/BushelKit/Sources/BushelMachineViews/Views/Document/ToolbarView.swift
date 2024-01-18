//
// ToolbarView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import Foundation
  import SwiftUI

  struct ToolbarView: View {
    let url: URL?
    let canSaveSnapshot: Bool
    let canStart: Bool
    let saveSnapshot: (SnapshotRequest) -> Void

    @Environment(\.openWindow) var openWindow

    var body: some View {
      Button {
        self.saveSnapshot(.init())
      } label: {
        Image(systemName: "camera")
        Text(.snapshotMachine)
      }
      .disabled(!self.canSaveSnapshot)
      Button {
        if let url {
          openWindow(value: SessionRequest(url: url))
        }
      } label: {
        if canStart {
          Image(systemName: "play")
          Text(.startMachine)
        } else {
          Image(systemName: "display")
          Text(.openMachine)
        }
      }
      .disabled(self.url == nil)
    }
  }
#endif
