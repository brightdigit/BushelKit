//
//  SigVerificationManaging.swift
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

/// A protocol that manages the verification of signatures.
public protocol SigVerificationManaging: Sendable {
  /// Resolves the `SigVerifier` for the given `VMSystemID`.
  ///
  /// - Parameter id: The `VMSystemID` to resolve the `SigVerifier` for.
  /// - Returns: The `SigVerifier` for the given `VMSystemID`.
  func resolve(_ id: VMSystemID) -> SigVerifier
}

extension SigVerificationManaging {
  /// Checks if a signature is signed from the given `SignatureSource` for the specified `VMSystemID`.
  ///
  /// - Parameters:
  ///   - source: The `SignatureSource` to check the signature from.
  ///   - id: The `VMSystemID` to check the signature for.
  /// - Returns: The `SigVerification` result.
  /// - Throws: A `SigVerificationError` if the signature verification fails.
  public func isSignatureSigned(from source: SignatureSource, for id: VMSystemID)
    async throws(SigVerificationError) -> SigVerification
  {
    try await self.resolve(id).isSignatureSigned(from: source)
  }
}
