//
// AVPlayer.swift
// Copyright (c) 2023 BrightDigit.
//

public enum VideoResource {
  public static let defaultFileExtension = "mp4"
}

#if canImport(AVKit)
  import AVKit
  import Foundation

  public extension AVPlayer {
    static var defaultResourceFileExtension: String {
      VideoResource.defaultFileExtension
    }

    static func resource(
      _ name: String,
      extension fileExtension: String = defaultResourceFileExtension
    ) -> AVPlayer! {
      let url = Bundle.module.url(forResource: name, withExtension: fileExtension)
      return url.map(AVPlayer.init(url:))
    }
  }

#endif
