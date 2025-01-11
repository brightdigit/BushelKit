//
//  SourceSigVerifier.swift
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

public import Foundation

/// A protocol that defines a source signature verifier.
public protocol SourceSigVerifier: Sendable {
  /// The unique identifier of the verifier system.
  var id: VMSystemID { get }

  /// The identifier of the source.
  var sourceID: String { get }

  /// The priority of the signature.
  var priority: SignaturePriority { get }

  /// Retrieves the image signature from the specified source and timestamp.
  ///
  /// - Parameters:
  ///   - source: The signature source.
  ///   - timestamp: The timestamp of the signature.
  /// - Returns: The image signature.
  /// - Throws: `SigVerificationError` if there is an error verifying the signature.
  func imageSignature(
    from source: SignatureSource,
    timestamp: Date
  ) async throws(SigVerificationError) -> ImageSignature
}

extension SourceSigVerifier {
  /// Retrieves the image signature from the specified source.
  ///
  /// - Parameter source: The signature source.
  /// - Returns: The image signature.
  /// - Throws: `SigVerificationError` if there is an error verifying the signature.
  public func imageSignature(
    from source: SignatureSource
  ) async throws(SigVerificationError) -> ImageSignature {
    try await self.imageSignature(from: source, timestamp: .now)
  }
}
