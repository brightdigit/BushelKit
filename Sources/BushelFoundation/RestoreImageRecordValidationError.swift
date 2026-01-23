//
//  RestoreImageRecordValidationError.swift
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

/// Validation errors for RestoreImageRecord.
public enum RestoreImageRecordValidationError: Error, Sendable, Equatable {
  /// SHA-256 hash has invalid length.
  case invalidSHA256Hash(String, expectedLength: Int)
  /// SHA-1 hash has invalid length.
  case invalidSHA1Hash(String, expectedLength: Int)
  /// SHA-256 hash contains non-hexadecimal characters.
  case nonHexadecimalSHA256(String)
  /// SHA-1 hash contains non-hexadecimal characters.
  case nonHexadecimalSHA1(String)
  /// File size is not positive.
  case nonPositiveFileSize(Int)
  /// Download URL does not use HTTPS.
  case insecureDownloadURL(URL)
}
