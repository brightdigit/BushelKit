//
//  AppleDBEntry.swift
//  BushelCloud
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

/// Represents a single macOS build entry from AppleDB
struct AppleDBEntry: Codable {
  let osStr: String
  let version: String
  let build: String?  // Some entries may not have a build number
  let uniqueBuild: String?
  let released: String  // ISO date or empty string
  let beta: Bool?
  let rc: Bool?
  let `internal`: Bool?
  let deviceMap: [String]
  let signed: SignedStatus
  let sources: [AppleDBSource]?

  enum CodingKeys: String, CodingKey {
    case osStr, version, build, uniqueBuild, released
    case beta, rc
    case `internal` = "internal"
    case deviceMap, signed, sources
  }
}
