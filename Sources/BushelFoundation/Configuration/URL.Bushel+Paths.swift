//
//  URL.Bushel+Paths.swift
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

extension URL.Bushel {
  /// A struct that contains various file and directory paths used by the app.
  public struct Paths: Sendable {
    /// A type alias for the `VZMacPaths` protocol.
    public typealias VZMac = VZMacPaths

    private enum Defaults {
      fileprivate static let restoreImagesDirectoryName = "Restore Images"
      fileprivate static let machineDataDirectoryName = "data"
      fileprivate static let snapshotsDirectoryName = "snapshots"
      fileprivate static let captureImageDirectoryName = "images"
      fileprivate static let captureVideoDirectoryName = "videos"
      fileprivate static let machineJSONFileName = "machine.json"
      fileprivate static let restoreLibraryJSONFileName = "metadata.json"
    }

    /// The name of the directory for restore images.
    public let restoreImagesDirectoryName = Defaults.restoreImagesDirectoryName
    /// The name of the directory for machine data.
    public let machineDataDirectoryName = Defaults.machineDataDirectoryName
    /// The name of the directory for snapshots.
    public let snapshotsDirectoryName = Defaults.snapshotsDirectoryName
    /// The name of the directory for captured videos.
    public let captureVideoDirectoryName = Defaults.captureVideoDirectoryName
    /// The name of the directory for captured images.
    public let captureImageDirectoryName = Defaults.captureImageDirectoryName
    /// The name of the file for the machine JSON data.
    public let machineJSONFileName = Defaults.machineJSONFileName
    /// The name of the file for the restore library JSON data.
    public let restoreLibraryJSONFileName = Defaults.restoreLibraryJSONFileName
  }
}
