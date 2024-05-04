//
// SessionToolbarView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelMachine
  import BushelMarketEnvironment
  import BushelViewsCore
  import SwiftUI

  struct SessionToolbarView: View {
    @Binding var screenSettings: ScreenSettings
    @Binding var sessionAutomaticSnapshotsEnabled: Bool
    @Binding var keepWindowOpenOnShutdown: Bool
    @Binding var isForceRestartRequested: Bool

    @AppStorage(for: Preference.MachineShutdownAction.self)
    var machineShutdownActionOption: MachineShutdownActionOption?

    @AppStorage(for: AutomaticSnapshots.Enabled.self)
    var automaticSnapshotsEnabled: Bool

    @Environment(\.marketplace) var marketplace

    let agent: any SessionToolbarAgent
    let onGeometryProxy: (GeometryProxy) -> Void

    var startPauseResume: some View {
      Group {
        if self.agent.canStart {
          Button {
            agent.start()
          } label: {
            Image(systemName: "play.fill")
          }
          .help(Text(LocalizedStringID.startMachine))
        } else if self.agent.canPause {
          Button {
            agent.pause()
          } label: {
            Image(systemName: "pause.fill")
          }
          .help(Text(LocalizedStringID.pauseMachine))
        } else if self.agent.canResume {
          Button {
            agent.resume()
          } label: {
            Image(systemName: "play")
          }
          .help(Text(LocalizedStringID.resumeMachine))
        } else {
          ProgressView().scaleEffect(0.5)
        }
      }
    }

    var body: some View {
      Toggle(
        LocalizedStringID.sessionAutomaticallyReconfigureDisplayToggle,
        systemImage: "square.resize.up",
        isOn: self.$screenSettings.automaticallyReconfiguresDisplay
      )
      .hidden()
      if marketplace.purchased, automaticSnapshotsEnabled {
        Toggle(
          LocalizedStringID.settingsAutomaticSnapshotsLabel,
          systemImage: "camera.badge.clock.fill",
          isOn: self.$sessionAutomaticSnapshotsEnabled
        )
        .help(Text(.settingsAutomaticSnapshotsLabel))
      }
      Toggle(
        LocalizedStringID.keepWindowOpenOnShutdown,
        systemImage: "lock.fill",
        isOn: self.$keepWindowOpenOnShutdown
      )
      .help(Text(.keepWindowOpenOnShutdown))
      .isHidden(self.machineShutdownActionOption == .closeWindow)
      Toggle(
        LocalizedStringID.sessionCaptureSystemKeysToggle,
        systemImage: "command.square.fill",
        isOn: self.$screenSettings.capturesSystemKeys
      )
      .help(Text(.sessionCaptureSystemKeysToggle))
      Button {
        self.agent.snapshot(.init(), options: [])
      } label: {
        Image(systemName: "camera")
      }
      .help(Text(.snapshotMachine))
      self.startPauseResume.tint(.primary)
      Button {
        self.isForceRestartRequested = true
      } label: {
        Image(systemName: "restart.circle.fill")
      }
      .help(Text(.sessionForceRestartTitle))
      Button {
        self.agent.pressPowerButton()
      } label: {
        Image(systemName: "power")
      }
      .help(Text(.sessionPressPowerButton))
      .disabled(!self.agent.canPressPowerButton)
      .tint(.primary)
      .background(content: {
        GeometryReader { proxy in
          Color.clear.onAppear {
            onGeometryProxy(proxy)
          }
        }
      })
    }
  }
#endif
