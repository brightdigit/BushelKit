//
// AVPlayer.swift
// Copyright (c) 2024 BrightDigit.
//

public enum VideoResource {
  public static let defaultFileExtension = "mp4"
}

#if canImport(AVKit)
  import AVKit
  import Foundation

  extension AVPlayer {
    public static var defaultResourceFileExtension: String {
      VideoResource.defaultFileExtension
    }

    public static func resource(
      _ name: String,
      extension fileExtension: String = defaultResourceFileExtension
      // swiftlint:disable:next implicitly_unwrapped_optional
    ) -> AVPlayer! {
      let url = Bundle.module.url(forResource: name, withExtension: fileExtension)
      return url.map(AVPlayer.init(url:))
    }
  }

#endif
