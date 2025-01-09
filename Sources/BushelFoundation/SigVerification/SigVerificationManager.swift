//
//  SigVerificationManager.swift
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

/// A manager for handling signature verification across different systems.
public struct SigVerificationManager: SigVerificationManaging {
  /// A dictionary of signature verifiers, keyed by their system IDs.
  private let implementations: [VMSystemID: any SigVerifier]

  /// Initializes a `SigVerificationManager` with the provided signature verifiers.
  ///
  /// - Parameter implementations: An array of signature verifiers.
  private init(implementations: [VMSystemID: any SigVerifier]) {
    self.implementations = implementations
  }

  /// Initializes a `SigVerificationManager` with the provided signature verifiers.
  ///
  /// - Parameter implementations: An array of signature verifiers.
  public init(_ implementations: [any SigVerifier]) {
    self.init(implementations: .init(uniqueValues: implementations, keyBy: \.id))
  }

  /// Resolves a signature verifier for the given system ID.
  ///
  /// - Parameter id: The system ID for which to resolve the signature verifier.
  /// - Returns: The signature verifier for the given system ID.
  public func resolve(_ id: VMSystemID) -> any SigVerifier {
    guard let implementations = implementations[id] else {
      // Self.logger.critical("Unknown system: \(id.rawValue)")
      preconditionFailure("")
    }

    return implementations
  }
}
