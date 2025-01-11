//
//  RecordedVideoParser.swift
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

/// A protocol that defines a RecordedVideoParser.
public protocol RecordedVideoParser {
  /// Parses the video information from the given `CaptureVideo` and
  /// stores the `RecordedVideo` in the specified directory.
  ///
  /// - Parameters:
  ///   - video: The `CaptureVideo` to parse.
  ///   - directoryURL: The URL of the directory to store the `RecordedVideo`.
  ///
  /// - Throws: `RecordedVideoError` if an error occurs during the parsing.
  ///
  /// - Returns: The parsed `RecordedVideo`.
  func videoInfo(fromVideo video: CaptureVideo, toDirectory directoryURL: URL)
    async throws(RecordedVideoError) -> RecordedVideo
}
