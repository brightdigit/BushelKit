//
//  ImageSignature.swift
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
public import OSVer

/// Represents an image signature,
/// containing information about the source, system, and verification details.
public struct ImageSignature: Sendable {
  /// The unique identifier of the source.
  public let sourceID: String

  /// The unique identifier of the signature.
  public let signatureID: String

  /// The unique identifier of the virtual machine system.
  public let vmSystemID: VMSystemID

  /// The version of the operating system.
  public let operatingSystemVersion: OSVer

  /// The build version of the operating system, if available.
  public let buildVersion: String?

  /// The verification details of the signature.
  public let verification: SigVerification

  /// The priority of the signature.
  public let priority: SignaturePriority

  /// The timestamp of the signature.
  public let timestamp: Date

  /// The build ID, which is a combination of the operating system version and the build version.
  public var buildID: String {
    self.operatingSystemVersion.id(buildVersion: self.buildVersion)
  }

  /// Initializes an `ImageSignature` instance.
  ///
  /// - Parameters:
  ///   - sourceID: The unique identifier of the source.
  ///   - signatureID: The unique identifier of the signature.
  ///   - vmSystemID: The unique identifier of the virtual machine system.
  ///   - operatingSystemVersion: The version of the operating system.
  ///   - buildVersion: The build version of the operating system, if available.
  ///   - verification: The verification details of the signature.
  ///   - priority: The priority of the signature.
  ///   - timestamp: The timestamp of the signature.
  public init(
    sourceID: String,
    signatureID: String,
    vmSystemID: VMSystemID,
    operatingSystemVersion: OSVer,
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
