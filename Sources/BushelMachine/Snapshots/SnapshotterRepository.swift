//
//  SnapshotterRepository.swift
//  Sublimation
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

public import BushelCore

public struct SnapshotterRepository: SnapshotProvider {
  private let dictionary: [SnapshotterID: any SnapshotterFactory]

  public init(factories: [any SnapshotterFactory] = []) {
    let uniqueKeysWithValues = factories.map { (type(of: $0).systemID, $0) }

    self.init(dictionary: .init(uniqueKeysWithValues: uniqueKeysWithValues))
  }

  init(dictionary: [SnapshotterID: any SnapshotterFactory]) { self.dictionary = dictionary }

  public func snapshotter<MachineType: Machine>(
    withID id: SnapshotterID,
    for machineType: MachineType.Type
  ) -> (any Snapshotter<MachineType>)? {
    guard let anySnapshotter = dictionary[id] else {
      #warning("logging-note: should we log here?")
      return nil
    }

    return anySnapshotter.snapshotter(supports: machineType)
  }
}