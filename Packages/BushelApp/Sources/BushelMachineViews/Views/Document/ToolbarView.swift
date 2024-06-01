//
// ToolbarView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import Foundation
  import SwiftUI

  internal struct ToolbarView: View {
    let url: URL?
    let canSaveSnapshot: Bool
    let allowedToSaveSnapshot: Bool
    let canStart: Bool
    let saveSnapshot: (SnapshotRequest) -> Void

    @Binding var purchasePrompt: Bool
    @Environment(\.openWindow) var openWindow

    var body: some View {
      Button {
        if allowedToSaveSnapshot {
          self.saveSnapshot(.init())
        } else {
          self.purchasePrompt = true
        }
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
