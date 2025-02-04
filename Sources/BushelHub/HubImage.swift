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

public struct HubImage: Identifiable, InstallImage, Sendable {
  public let title: String
  public let metadata: ImageMetadata
  public let url: URL
  public let verification: SigVerification
  public var id: URL { self.url }

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
