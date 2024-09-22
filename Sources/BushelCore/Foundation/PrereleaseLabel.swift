//
//  PrereleaseLabel.swift
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

public struct PrereleaseLabel: Sendable {
  public let label: String
  private let baseNumber: Int

  public init(label: String, baseNumber: Int) {
    self.label = label
    self.baseNumber = baseNumber
  }
}

extension PrereleaseLabel {
  public enum Keys: String {
    case label = "Label"
    case base = "Base"
  }

  public init?(dictionary: [String: Any]) {
    guard let label = dictionary[Keys.label.rawValue] as? String,
      let base = dictionary[Keys.base.rawValue] as? Int
    else {
      assertionFailure("Bundle InfoDictionary Missing Label and Base for Prerelease Info")
      return nil
    }
    self.init(label: label, baseNumber: base)
  }

  public func offset(fromBuildNumber buildNumber: Int, additionalOffset: Int, factorOf factor: Int)
    -> Int
  { (buildNumber - baseNumber + additionalOffset) / factor }
}
