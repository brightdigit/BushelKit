//
// SessionToolbarView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelMachine
  import SwiftUI

  struct SessionToolbarView: View {
    @Binding var screenSettings: ScreenSettings
    let agent: SessionToolbarAgent
    let onGeometryProxy: (GeometryProxy) -> Void

    var startPauseResume: some View {
      Group {
        if self.agent.canStart {
          Button {
            agent.start()
          } label: {
            Image(systemName: "play.fill")
          }
        } else if self.agent.canPause {
          Button {
            agent.pause()
          } label: {
            Image(systemName: "pause.fill")
          }
        } else if self.agent.canResume {
          Button {
            agent.resume()
          } label: {
            Image(systemName: "play")
          }
        } else {
          ProgressView().scaleEffect(0.5)
        }
      }
    }

    var body: some View {
      Toggle(
        LocalizedStringID.sessionAutomaticallyReconfigureDisplayToggle.key,
        systemImage: "square.resize.up",
        isOn: self.$screenSettings.automaticallyReconfiguresDisplay
      )
      .hidden()
      Toggle(
        LocalizedStringID.sessionCaptureSystemKeysToggle.key,
        systemImage: "command.square.fill",
        isOn: self.$screenSettings.capturesSystemKeys
      )
      Button {
        self.agent.snapshot(.init(), options: [])
      } label: {
        Image(systemName: "camera")
      }
      self.startPauseResume.tint(.primary)
      Button {
        self.agent.pressPowerButton()
      } label: {
        Image(systemName: "power")
      }
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

//  #Preview {
//    SessionToolbarView()
//  }
#endif
