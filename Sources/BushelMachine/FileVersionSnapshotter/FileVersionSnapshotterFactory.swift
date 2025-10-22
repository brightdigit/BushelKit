//
//  FileVersionSnapshotterFactory.swift
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

#if os(macOS)

  public import BushelFoundation
  internal import Foundation

  /// A factory for creating file version snapshots.
  public struct FileVersionSnapshotterFactory: SnapshotterFactory {
    /// The unique identifier for the file version snapshotter.
    public static var systemID: SnapshotterID {
      .fileVersion
    }

    /// Initializes a new instance of the `FileVersionSnapshotterFactory`.
    public init() {}

    /// Creates a new snapshot for the given machine, request, and options.
    ///
    /// - Parameters:
    ///   - machine: The machine to create the snapshot for.
    ///   - request: The snapshot request.
    ///   - options: The snapshot options.
    /// - Returns: The created snapshot.
    public func createNewSnapshot(
      of machine: some Machine,
      request: SnapshotRequest,
      options: SnapshotOptions,
      image: RecordedImage?
    ) async throws -> Snapshot {
      guard let snapshotter = self.snapshotter(supports: type(of: machine).self) else {
        fatalError("Not implemented error")
      }

      return try await snapshotter.createNewSnapshot(
        of: machine,
        request: request,
        options: options,
        image: image
      )
    }

    /// Retrieves the snapshotter that supports the given machine type.
    ///
    /// - Parameter supports: The machine type to find a snapshotter for.
    /// - Returns: The snapshotter that supports the given machine type,
    ///  or `nil` if no such snapshotter is found.
    public func snapshotter<MachineType>(
      supports: MachineType.Type
    ) -> (any Snapshotter<MachineType>)? where MachineType: Machine {
      FileVersionSnapshotter(for: supports)
    }
  }
#endif
