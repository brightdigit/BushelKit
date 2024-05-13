//
//  Localizable.swift
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

public protocol Localizable: Hashable {
  static var emptyLocalizedStringID: String { get }
  static var defaultLocalizedStringID: String { get }
  static var localizedStringIDMapping: [Self: String] { get }
}

extension Localizable {
  public static var emptyLocalizedStringID: String {
    ""
  }

  public static var defaultLocalizedStringID: String {
    emptyLocalizedStringID
  }

  public var localizedStringIDRawValue: String {
    let string = Self.localizedStringIDMapping[self]
    assert(string != nil)
    return string ?? ""
  }
}

extension Optional where Wrapped: Localizable {
  public var localizedStringIDRawValue: String {
    guard let value = self else {
      return Wrapped.defaultLocalizedStringID
    }
    let string = Wrapped.localizedStringIDMapping[value]
    assert(string != nil)
    return string ?? ""
  }
}
