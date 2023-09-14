//
// SessionView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelLogging
  import BushelMachine
  import BushelMachineEnvironment
  import BushelViewsCore
  import SwiftUI

  struct SessionView: View {
    @Binding var request: SessionRequest?
    @State var object = SessionObject()
    @State var hasIntialStarted = false
    @State var closeOnShutdown = false

    var waitingForShutdown: Bool = false
    @Environment(\.metadataLabelProvider) var labelProvider
    @Environment(\.machineSystemManager) var systemManager
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(\.installerImageRepository) private var machineRestoreImageDBFrom

    var startPauseResume: some View {
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
        Button {} label: {
          Image(systemName: "questionmark.app.dashed")
        }
      }
    }

    var body: some View {
      ZStack {
        object.view()
      }

      .toolbar(content: {
        ToolbarItemGroup {
          self.startPauseResume.tint(.primary)

          // Button("power off button") {} // save snapshot

          Button {
            self.object.beginShutdown()
          } label: {
            Image(systemName: "power")
          }.disabled(!self.object.canRequestStop).tint(.primary)
        }
      })
      .alert(
        "Shutdown Machine",
        isPresented: self.$object.presentConfirmCloseAlert
      ) {
        Button {
          closeOnShutdown = true
          self.object.beginShutdown()
        } label: {
          Text("Press Power Button")
        }

        Button {} label: {
          Text("Save State and Turn Off")
        }.disabled(true)

        Button {
          closeOnShutdown = true
          self.object.begin { machine in
            try await machine.stop()
          }
        } label: {
          Text("Turn Off")
        }
      } message: {
        Text("How would you like to shutdown your machine?")
      }
      .onCloseButton(self.$object.windowClose, self.object.shouldCloseWindow(_:))
      .onChange(of: request?.url) { _, newValue in
        if let url = newValue {
          self.object.loadURL(
            url,
            withContext: context,
            restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
            using: systemManager,
            labelProvider: self.labelProvider.callAsFunction(_:_:)
          )
        }
      }
      .onAppear {
        if let url = self.request?.url {
          self.object.loadURL(
            url,
            withContext: context,
            restoreImageDBfrom: machineRestoreImageDBFrom.callAsFunction(_:),
            using: systemManager,
            labelProvider: self.labelProvider.callAsFunction(_:_:)
          )
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
