//
//  ProgressOperation.swift
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

public protocol ProgressOperation<ValueType>: Identifiable, Sendable where ID == URL {
  associatedtype ValueType: BinaryInteger & Sendable
  var currentValue: ValueType { get }
  var totalValue: ValueType? { get }
  func execute() async throws
}

extension ProgressOperation {
  public func percentValue(withFractionDigits fractionDigits: Int = 0) -> String? {
    guard let totalValue else {
      #warning("logging-note: should we log something here?")
      return nil
    }
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = fractionDigits
    formatter.minimumFractionDigits = fractionDigits
    let ratioValue = Double(currentValue) / Double(totalValue) * 100.0
    let string = formatter.string(from: .init(value: ratioValue))

    #warning("logging-note: let's log the calculated percent value if not done somewhere")
    assert(string != nil)
    return string
  }
}
