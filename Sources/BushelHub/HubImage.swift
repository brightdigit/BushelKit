//
//  HubImage.swift
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
public import Foundation

/// An installable OS image provided by a hub.
public struct HubImage: Identifiable, InstallImage, Sendable {
  /// The human-readable title of the image.
  public let title: String
  /// Metadata describing the image.
  public let metadata: ImageMetadata
  /// The location of the image.
  public let url: URL
  /// The signature verification status of the image.
  public let verification: SigVerification
  /// The unique identifier of the image, derived from its URL.
  public var id: URL { self.url }

  /// Creates a hub image.
  /// - Parameters:
  ///   - title: The human-readable title of the image.
  ///   - metadata: Metadata describing the image.
  ///   - verification: The signature verification status of the image.
  ///   - url: The location of the image.
  public init(title: String, metadata: ImageMetadata, verification: SigVerification, url: URL) {
    self.title = title
    self.metadata = metadata
    self.verification = verification
    assert(
      self.metadata.sigVerification == nil || self.metadata.sigVerification == verification,
      "Verification mismatch"
    )
    self.url = url
  }
}

extension ImageSignature {
  /// Creates an image signature from a hub image.
  /// - Parameters:
  ///   - sourceID: The identifier of the signature source.
  ///   - priority: The signature priority to apply.
  ///   - hubImage: The hub image whose details describe the signature.
  ///   - timestamp: The timestamp of the signature. Defaults to the current time.
  public init(
    sourceID: String, priority: SignaturePriority, hubImage: HubImage, timestamp: Date = .now
  ) {
    self.init(
      sourceID: sourceID,
      signatureID: hubImage.url.standardized.description,
      vmSystemID: hubImage.metadata.vmSystemID,
      operatingSystemVersion: hubImage.metadata.operatingSystemVersion,
      buildVersion: hubImage.metadata.buildVersion,
      verification: hubImage.verification,
      priority: priority,
      timestamp: timestamp
    )
  }
}
