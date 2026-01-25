//
//  SigVerifier+FindVerification.swift
//  BushelKit
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

extension SigVerifier {
  /// Attempts to find verification for a signature source, returning nil if not found.
  ///
  /// This is a convenience wrapper around `isSignatureSigned(from:)` that treats
  /// the `.notFound` error case as a `nil` result instead of throwing.
  ///
  /// - Parameter source: The source of the signature to be verified.
  /// - Returns: The signature verification if found, or `nil` if not found.
  /// - Throws: A `SigVerificationError` if verification fails for reasons other than not found.
  public func findVerification(for source: SignatureSource) async throws(SigVerificationError)
    -> SigVerification?
  {
    do {
      return try await self.isSignatureSigned(from: source)
    } catch SigVerificationError.notFound {
      return nil
    }
  }
}
