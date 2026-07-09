//
//  MockSigVerifier.swift
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

public import BushelFoundation

/// A mock signature verifier that always returns a preconfigured verification result, for testing.
public actor MockSigVerifier: SigVerifier {
  /// The identifier of the VM system this verifier is associated with.
  public let id: VMSystemID
  /// The fixed verification result returned for every signature check.
  public var verification: SigVerification

  /// Creates a mock verifier with the given system identifier and verification result.
  ///
  /// - Parameters:
  ///   - id: The identifier of the VM system this verifier is associated with.
  ///   - verification: The verification result to always return.
  public init(id: VMSystemID, verification: SigVerification) {
    self.id = id
    self.verification = verification
  }

  /// Returns the preconfigured verification result for the given signature source.
  ///
  /// - Parameter source: The signature source to check (ignored by this mock).
  /// - Returns: The fixed `verification` result.
  public func isSignatureSigned(
    from source: SignatureSource
  ) async throws(SigVerificationError) -> SigVerification {
    verification
  }
}
