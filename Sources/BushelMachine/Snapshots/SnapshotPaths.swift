//
//  SnapshotPaths.swift
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

/// Represents the paths for a snapshotting operation.
public struct SnapshotPaths {
  /// The URL of the source to be snapshotted.
  public let snapshottingSourceURL: URL
  /// The URL of the directory where the snapshots will be collected.
  public let snapshotCollectionURL: URL

  /// Initializes a new `SnapshotPaths` instance using the provided machine path URL.
  ///
  /// - Parameter machinePathURL: The URL of the machine path.
  public init(machinePathURL: URL) {
    self.init(
      snapshottingSourceURL: machinePathURL,
      snapshotCollectionURL: machinePathURL.appendingPathComponent(
        URL.bushel.paths.snapshotsDirectoryName
      )
    )
  }

  /// Initializes a new `SnapshotPaths` instance with the provided URLs.
  ///
  /// - Parameters:
  ///   - snapshottingSourceURL: The URL of the source to be snapshotted.
  ///   - snapshotCollectionURL: The URL of the directory where the snapshots will be collected.
  public init(snapshottingSourceURL: URL, snapshotCollectionURL: URL) {
    self.snapshottingSourceURL = snapshottingSourceURL
    self.snapshotCollectionURL = snapshotCollectionURL
  }
}
