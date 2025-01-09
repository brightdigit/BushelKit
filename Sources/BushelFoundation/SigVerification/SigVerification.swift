//
//  SigVerification.swift
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

/// Represents the signature verification state of a message.
public enum SigVerification: Int, Sendable, Codable, CustomDebugStringConvertible {
  /// The message is unsigned.
  case unsigned
  /// The message is signed.
  case signed

  /// A textual description of the verification state.
  public var debugDescription: String {
    switch self {
    case .signed:
      "Signed"
    case .unsigned:
      "Unsigned"
    }
  }
}

extension SigVerification {
  /// Initializes a `SigVerification` instance based on the specified signing state.
  ///
  /// - Parameter isSigned: A Boolean value indicating whether the message is signed.
  public init(isSigned: Bool) {
    self = isSigned ? .signed : .unsigned
  }
}
