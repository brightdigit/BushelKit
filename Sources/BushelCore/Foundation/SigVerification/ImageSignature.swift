//
//  ImageSignature.swift
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

public import Foundation

public struct ImageSignature: Sendable {
  public let sourceID: String
  public let signatureID: String
  public let vmSystemID: VMSystemID
  public let operatingSystemVersion: OperatingSystemVersion
  public let buildVersion: String?
  public let verification: SigVerification
  public let priority: SignaturePriority
  public let timestamp: Date
  public var buildID: String {
    operatingSystemVersion.id(buildVersion: self.buildVersion)
  }

  public init(
    sourceID: String,
    signatureID: String,
    vmSystemID: VMSystemID,
    operatingSystemVersion: OperatingSystemVersion,
    buildVersion: String?,
    verification: SigVerification,
    priority: SignaturePriority,
    timestamp: Date
  ) {
    self.sourceID = sourceID
    self.signatureID = signatureID
    self.vmSystemID = vmSystemID
    self.operatingSystemVersion = operatingSystemVersion
    self.buildVersion = buildVersion
    self.priority = priority
    self.verification = verification
    self.timestamp = timestamp
  }
}
