//
// AVPlayer.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(AVKit)
  import AVKit
  import Foundation

  public extension AVPlayer {
    static func resource(_ name: String, extension fileExtension: String = "mp4") -> AVPlayer! {
      let url = Bundle.module.url(forResource: name, withExtension: fileExtension)
      return url.map(AVPlayer.init(url:))
    }
  }

#endif
