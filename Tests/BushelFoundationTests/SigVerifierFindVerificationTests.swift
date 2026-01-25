//
//  SigVerifierFindVerificationTests.swift
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

import Testing
@testable import BushelFoundation

struct SigVerifierFindVerificationTests {
  
  @Test("findVerification returns successful verification result when signed")
  func testFindVerificationReturnsSignedResult() async throws {
    let verifier = MockSigVerifierReturning(verification: .signed)
    let source = SignatureSource.dummy // This will be whatever mock source we have
    
    let result = try await verifier.findVerification(for: source)
    
    #expect(result == .signed)
  }
  
  @Test("findVerification returns successful verification result when unsigned")
  func testFindVerificationReturnsUnsignedResult() async throws {
    let verifier = MockSigVerifierReturning(verification: .unsigned)
    let source = SignatureSource.dummy
    
    let result = try await verifier.findVerification(for: source)
    
    #expect(result == .unsigned)
  }
  
  @Test("findVerification returns nil when notFound error occurs")
  func testFindVerificationReturnsNilForNotFound() async throws {
    let verifier = MockSigVerifierWithError(error: .notFound)
    let source = SignatureSource.dummy
    
    let result = try await verifier.findVerification(for: source)
    
    #expect(result == nil)
  }
  
  @Test("findVerification propagates unsupportedSource error")
  func testFindVerificationPropagatesUnsupportedSourceError() async throws {
    let verifier = MockSigVerifierWithError(error: .unsupportedSource)
    let source = SignatureSource.dummy
    
    await #expect { 
      _ = try await verifier.findVerification(for: source) 
    } throws: { error in
      if case SigVerificationError.unsupportedSource = error {
        return true
      }
      return false
    }
  }
  
  @Test("findVerification propagates internalError")
  func testFindVerificationPropagatesInternalError() async throws {
    struct TestError: Error {}
    let internalError = TestError()
    let verifier = MockSigVerifierWithError(error: .internalError(internalError))
    let source = SignatureSource.dummy
    
    await #expect {
      _ = try await verifier.findVerification(for: source)
    } throws: { error in
      if case let SigVerificationError.internalError(underlyingError) = error {
        return underlyingError is TestError
      }
      return false
    }
  }
  
  @Test("findVerification propagates unknownError")
  func testFindVerificationPropagatesUnknownError() async throws {
    struct TestError: Error {}
    let unknownError = TestError()
    let verifier = MockSigVerifierWithError(error: .unknownError(unknownError))
    let source = SignatureSource.dummy
    
    await #expect {
      _ = try await verifier.findVerification(for: source)
    } throws: { error in
      if case let SigVerificationError.unknownError(underlyingError) = error {
        return underlyingError is TestError
      }
      return false
    }
  }
}

// Mock implementation that returns specific verification
actor MockSigVerifierReturning: SigVerifier {
  let id: VMSystemID = "test-system"
  let verification: SigVerification
  
  init(verification: SigVerification) {
    self.verification = verification
  }
  
  func isSignatureSigned(from source: SignatureSource) async throws(SigVerificationError) -> SigVerification {
    verification
  }
}

// Mock implementation that throws specific errors
actor MockSigVerifierWithError: SigVerifier {
  let id: VMSystemID = "test-system"
  let error: SigVerificationError
  
  init(error: SigVerificationError) {
    self.error = error
  }
  
  func isSignatureSigned(from source: SignatureSource) async throws(SigVerificationError) -> SigVerification {
    throw error
  }
}

// Extension to provide a dummy SignatureSource for testing
extension SignatureSource {
  static var dummy: SignatureSource {
    .signatureID("test-signature-id")
  }
}