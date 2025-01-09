//
//  MediaParserFactory.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

/// A default implementation of `RecordedVideoParser`.
private struct DefaultVideoParser: RecordedVideoParser {
  /// The default instance of `DefaultVideoParser`.
  static let `default`: DefaultVideoParser = .init()

  /// Retrieves video information from a `CaptureVideo` object and saves it to the specified directory.
  ///
  /// - Parameters:
  ///   - video: The `CaptureVideo` object containing the video information.
  ///   - directoryURL: The URL of the directory where the video information should be saved.
  /// - Throws: `RecordedVideoError` if an error occurs during the video information retrieval.
  /// - Returns: The `RecordedVideo` object containing the video information.
  fileprivate func videoInfo(
    fromVideo _: CaptureVideo,
    toDirectory _: URL
  ) async throws(RecordedVideoError) -> RecordedVideo {
    assertionFailure("Not Implemented.")
    throw .notImplmented
  }
}

/// A factory for creating `RecordedImageParser` and `RecordedVideoParser` instances.
public struct MediaParserFactory: Sendable {
  /// A closure that returns an `any RecordedImageParser` instance.
  public let getImageParser: @Sendable () -> any RecordedImageParser
  /// A closure that returns an `any RecordedVideoParser` instance.
  public let getVideoParser: @Sendable () -> any RecordedVideoParser

  /// Initializes a `MediaParserFactory` instance with the given image and video parser closures.
  ///
  /// - Parameters:
  ///   - imageParser: A closure that returns an `any RecordedImageParser` instance.
  ///   - videoParser: A closure that returns an `any RecordedVideoParser` instance.
  public init(
    imageParser: @escaping @Sendable () -> any RecordedImageParser,
    videoParser: @escaping @Sendable () -> any RecordedVideoParser
  ) {
    self.getImageParser = imageParser
    self.getVideoParser = videoParser
  }
}

extension MediaParserFactory {
  /// The default `MediaParserFactory` instance.
  public static let `default`: MediaParserFactory = .init {
    ImageFileParser(
      fileManager: .default,
      cgSizeFromURL: defaultCGSizeFromURL(_:)
    )
  } videoParser: {
    DefaultVideoParser.default
  }

  /// Initializes a `MediaParserFactory` instance
  /// with the given file manager, CGSize retrieval closure, and video parser closure.
  ///
  /// - Parameters:
  ///   - fileManager: A closure that returns a `FileManager` instance.
  ///   Defaults to `.default`.
  ///   - cgSizeFromURL: A closure that retrieves the CGSize for a given URL.
  ///   Defaults to `defaultCGSizeFromURL(_:)`.
  ///   - videoParser: A closure that returns an `any RecordedVideoParser` instance.
  public init(
    fileManager: @Sendable @escaping () -> FileManager = { .default },
    cgSizeFromURL: @Sendable @escaping (URL) -> CGSize?,
    videoParser: @escaping @Sendable () -> any RecordedVideoParser
  ) {
    self.init(
      imageParser: {
        ImageFileParser(fileManager: fileManager(), cgSizeFromURL: cgSizeFromURL)
      },
      videoParser: videoParser
    )
  }

  private static func defaultCGSizeFromURL(_: URL) -> CGSize? {
    assertionFailure("Not Implemented.")
    return nil
  }
}
