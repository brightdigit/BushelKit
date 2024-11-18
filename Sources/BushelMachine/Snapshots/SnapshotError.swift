//
//  SnapshotError.swift
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

import Foundation

internal enum SnapshotError: Error, LocalizedError, Sendable {
  case innerError(any Error)
  case missingSnapshotVersionID(UUID)
  case missingSnapshotVersionAt(URL)
  case missingSnapshotFile(UUID)
  case unarchiveError(Data)

  internal var errorDescription: String? {
    Self.description(from: self)
  }

  internal static func inner(error: any Error) -> SnapshotError {
    if let snapshotError = error as? SnapshotError {
      snapshotError
    } else {
      .innerError(error)
    }
  }

  internal static func description(from error: any Error) -> String {
    guard let error = error as? SnapshotError else {
      assertionFailure(error.localizedDescription)
      return error.localizedDescription
    }
    switch error {
    case let .innerError(error):
      assertionFailure(error.localizedDescription)
      return error.localizedDescription
    case let .missingSnapshotVersionID(id):
      return "Missing Snapshot Based on Info from ID: \(id)"
    case let .missingSnapshotVersionAt(url):
      return "Missing Snapshot at \(url)"
    case let .missingSnapshotFile(id):
      return "Missing Snapshot File with ID: \(id)"
    case let .unarchiveError(data):
      return "Unable to Parse Snapshot ID from Data: \(data)"
    }
  }
}
