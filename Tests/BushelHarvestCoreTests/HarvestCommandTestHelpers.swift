//
//  HarvestCommandTestHelpers.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

@testable import BushelHarvestCore

extension HarvestCommand {
  /// Test convenience: builds a command whose payload matches `category`.
  ///
  /// The production API intentionally requires an explicit ``CommandPayload``
  /// (the factory methods such as ``HarvestCommand/system(_:)`` keep category
  /// and payload consistent). Tests that only care about the category use this
  /// helper to pair each category with a representative payload.
  init(id: UUID = UUID(), category: CommandCategory) {
    let payload: CommandPayload
    switch category {
    case .system:
      payload = .system(.ping)
    case .file:
      payload = .file("test")
    case .network:
      payload = .network("test")
    case .clipboard:
      payload = .clipboard("test")
    case .remote:
      payload = .remote(.status)
    case .security:
      payload = .security(.status)
    }
    self.init(id: id, category: category, payload: payload)
  }
}
