//
//  MediaParserFactory.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
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

private struct DefaultVideoParser: RecordedVideoParser {
  static let `default`: DefaultVideoParser = .init()

  fileprivate func videoInfo(
    fromVideo video: CaptureVideo,
    toDirectory directoryURL: URL
  ) async throws(RecordedVideoError) -> RecordedVideo {
    assertionFailure("Not Implemented.")
    throw .notImplmented
  }
}

public struct MediaParserFactory: Sendable {
  public let getImageParser: @Sendable () -> any RecordedImageParser
  public let getVideoParser: @Sendable () -> any RecordedVideoParser

  public init(
    imageParser: @escaping @Sendable () -> any RecordedImageParser,
    videoParser: @escaping @Sendable () -> any RecordedVideoParser
  ) {
    self.getImageParser = imageParser
    self.getVideoParser = videoParser
  }
}

extension MediaParserFactory {
  public static let `default`: MediaParserFactory = .init {
    ImageFileParser(
      fileManager: .default,
      cgSizeFromURL: defaultCGSizeFromURL(_:)
    )
  } videoParser: {
    DefaultVideoParser.default
  }

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

  private static func defaultCGSizeFromURL(_ url: URL) -> CGSize? {
    assertionFailure("Not Implemented.")
    return nil
  }
}
