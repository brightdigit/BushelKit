//
// SessionView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelLocalization
  import BushelLogging
  import BushelMachine
  import BushelMachineEnvironment
  import BushelMarketEnvironment
  import BushelViewsCore
  import StoreKit
  import SwiftUI

  struct SessionView: View, LoggerCategorized {
    let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
    @Binding var request: SessionRequest?
    @State var object = SessionObject()
    @State var hasIntialStarted = false
    @State var closeOnShutdown = false
    @State var shouldDisplaySubscriptionStoreView = false

    var waitingForShutdown: Bool = false
    @Environment(\.metadataLabelProvider) var labelProvider
    @Environment(\.machineSystemManager) var systemManager
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.snapshotProvider) private var snapshotProvider
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom
    @Environment(\.marketplace) private var marketplace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.purchaseWindow) private var purchaseWindow

    var startPauseResume: some View {
      Group {
        if self.object.canStart {
          Button {
            self.object.begin { try await $0.start() }
          } label: {
            Image(systemName: "play.fill")
          }
        } else if self.object.canPause {
          Button {
            self.object.begin { try await $0.pause() }
          } label: {
            Image(systemName: "pause.fill")
          }
        } else if self.object.canResume {
          Button {
            self.object.begin { try await $0.resume() }
          } label: {
            Image(systemName: "play")
          }
        } else {
          ProgressView().scaleEffect(0.5)
        }
      }
    }

    var body: some View {
      ZStack {
        object.view()
      }

      .toolbar(content: {
        ToolbarItemGroup {
          Button {
            self.object.startSnapshot(.init(), options: [])
          } label: {
            Image(systemName: "camera")
          }
          self.startPauseResume.tint(.primary)
          Button {
            self.object.beginShutdown()
          } label: {
            Image(systemName: "power")
          }.disabled(!self.object.canRequestStop).tint(.primary)
        }
      })
      .confirmationDialog(
        "Shutdown Machine",
        isPresented: self.$object.presentConfirmCloseAlert
      ) {
        Button {
          closeOnShutdown = true
          self.object.beginShutdown()
        } label: {
          Text(.sessionPressPowerButton)
        }

        Button {
          if self.marketplace.purchased {
            closeOnShutdown = true
            self.object.stop(saveSnapshot: .init())
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
          closeOnShutdown = true
          self.object.stop(saveSnapshot: nil)
        } label: {
          Text(.sessionTurnOff)
        }

        Button("Cancel", role: .cancel) {}
      } message: {
        Text(.sessionShutdownAlert)
      }
      .onCloseButton(self.$object.windowClose, self.object.shouldCloseWindow(_:))
      .onReceive(self.timer, perform: { _ in
        if self.marketplace.purchased {
          self.object.startSnapshot(.init(), options: .discardable)
        }
      })
      .onChange(of: request?.url) { _, newValue in
        if let url = newValue {
          Task {
            await self.object.loadURL(
              url,
              withContext: context,
              restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
              snapshotFactory: self.snapshotProvider,
              using: systemManager,
              labelProvider: self.labelProvider.callAsFunction(_:_:)
            )
          }
        }
      }
      .onAppear {
        if let url = self.request?.url {
          Task {
            await self.object.loadURL(
              url,
              withContext: context,
              restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
              snapshotFactory: self.snapshotProvider,
              using: systemManager,
              labelProvider: self.labelProvider.callAsFunction(_:_:)
            )
          }
        }
      }
      .onChange(of: self.object.canStart) { _, newValue in
        guard newValue, !self.hasIntialStarted else {
          return
        }

        hasIntialStarted = true
        self.object.begin {
          try await $0.start()
        }
      }

      .onChange(of: self.object.state) { oldValue, newValue in
        if oldValue != .stopped, newValue == .stopped, self.closeOnShutdown {
          dismiss()
        }
      }
      .navigationTitle(
        Self.navigationTitle(from: self.object.machineObject, default: "Loading Session...")
      )
    }

    static func navigationTitle(
      from machineObject: MachineObject?,
      default defaultValue: String
    ) -> String {
      machineObject.map(Self.navigationTitle(from:)) ?? defaultValue
    }

    static func navigationTitle(from machineObject: MachineObject) -> String {
      "\(machineObject.entry.name) (\(machineObject.state))"
    }
  }
#endif
