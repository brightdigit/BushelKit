//
// SessionClosingActionsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import BushelMachine
  import SwiftUI

  struct SessionClosingActionsView: View {
    @Environment(\.purchaseWindow) var purchaseWindow
    @Environment(\.marketplace) var marketplace
    @Environment(\.openWindow) var openWindow

    @Binding var keepWindowOpenOnShutdown: Bool
    let pressPowerButton: () -> Void
    let stopAndSaveSnapshot: (SnapshotRequest?) -> Void

    var body: some View {
      Button {
        keepWindowOpenOnShutdown = true
        self.pressPowerButton()
      } label: {
        Text(.sessionPressPowerButton)
      }

      Button {
        if self.marketplace.purchased {
          keepWindowOpenOnShutdown = true
          self.stopAndSaveSnapshot(.init())
        } else {
          openWindow(value: self.purchaseWindow)
        }
      } label: {
        if self.marketplace.purchased {
          Text(LocalizedText.key(LocalizedStringID.sessionSaveAndTurnOff))
        } else {
          Text(LocalizedText.key(LocalizedStringID.sessionUpgradeSaveAndTurnOff))
        }
      }

      Button {
        keepWindowOpenOnShutdown = true
        self.stopAndSaveSnapshot(nil)
      } label: {
        Text(.sessionTurnOff)
      }

      Button("Cancel", role: .cancel) {}
    }

    internal init(
      keepWindowOpenOnShutdown: Binding<Bool>,
      pressPowerButton: @escaping () -> Void,
      stopAndSaveSnapshot: @escaping (SnapshotRequest?) -> Void
    ) {
      self._keepWindowOpenOnShutdown = keepWindowOpenOnShutdown
      self.pressPowerButton = pressPowerButton
      self.stopAndSaveSnapshot = stopAndSaveSnapshot
    }
  }

//  #Preview {
//    SessionClosingActionsView()
//  }
#endif
