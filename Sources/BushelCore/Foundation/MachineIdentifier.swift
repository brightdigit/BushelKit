//
//  MachineIdentifier.swift
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

/// A struct representing a unique identifier for a machine.
///
/// This struct conforms to the `Codable`, `Equatable`, and `Sendable` protocols,
/// allowing it to be encoded/decoded to different representations, compared for equality,
/// and safely transferred between processes.

/// A unique identifier for a machine.
public struct MachineIdentifier: Codable, Equatable, Sendable {
  /// Coding keys for the `MachineIdentifier` struct.
  public enum CodingKeys: String, CodingKey {
    /// The unique 64-bit identifier for the machine.
    case ecID = "ECID"
  }

  /// The unique 64-bit identifier for the machine.
  public let ecID: UInt64
}
