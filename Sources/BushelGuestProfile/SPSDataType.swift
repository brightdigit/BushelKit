//
//  SPSDataType.swift
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

/// Represents a type of data in the SPS (System Profile Snapshot) system.
public struct SPSDataType: Codable, Equatable, Sendable {
  /// The keys used for encoding and decoding the data type.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case archKind = "arch_kind"
    case lastModified
    case obtainedFrom = "obtained_from"
    case path
    case version
    case info
    case privateFramework = "private_framework"
  }

  /// The name of the data type.
  public let name: String
  /// The architecture kind of the data type, or `nil` if unknown.
  public let archKind: ArchKind?
  /// The date when the data type was last modified.
  public let lastModified: Date
  /// The source from which the data type was obtained.
  public let obtainedFrom: ObtainedFrom
  /// The file path of the data type.
  public let path: String
  /// The version of the data type, or `nil` if unknown.
  public let version: String?
  /// Additional information about the data type, or `nil` if unknown.
  public let info: String?
  /// Indicates whether the data type is a private framework, or `nil` if unknown.
  public let privateFramework: PrivateFramework?

  /// Initializes a new `SPSDataType` instance.
  ///
  /// - Parameters:
  ///   - name: The name of the data type.
  ///   - archKind: The architecture kind of the data type, or `nil` if unknown.
  ///   - lastModified: The date when the data type was last modified.
  ///   - obtainedFrom: The source from which the data type was obtained.
  ///   - path: The file path of the data type.
  ///   - version: The version of the data type, or `nil` if unknown.
  ///   - info: Additional information about the data type, or `nil` if unknown.
  ///   - privateFramework: Indicates whether the data type is a private framework, or `nil` if unknown.
  public init(
    name: String,
    archKind: ArchKind?,
    lastModified: Date,
    obtainedFrom: ObtainedFrom,
    path: String,
    version: String?,
    info: String?,
    privateFramework: PrivateFramework?
  ) {
    self.name = name
    self.archKind = archKind
    self.lastModified = lastModified
    self.obtainedFrom = obtainedFrom
    self.path = path
    self.version = version
    self.info = info
    self.privateFramework = privateFramework
  }
}
