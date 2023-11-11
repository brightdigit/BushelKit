//
// Video.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(AppKit)
  import AVKit
  import SwiftUI

  public struct Video: NSViewRepresentable {
    let player: AVPlayer?

    // swiftlint:disable:next implicitly_unwrapped_optional
    public init(using player: AVPlayer!) {
      assert(player != nil)
      self.player = player
    }

    public func makeNSView(context _: Context) -> AVPlayerView {
      let view = AVPlayerView()
      view.controlsStyle = .none
      view.player = player
      player?.play()
      return view
    }

    public func updateNSView(_: AVPlayerView, context _: Context) {}
  }
#endif
