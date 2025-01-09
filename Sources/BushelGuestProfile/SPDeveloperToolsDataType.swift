//
//  SPDeveloperToolsDataType.swift
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

/// A struct that represents the data type for SP Developer Tools.
public struct SPDeveloperToolsDataType: Codable, Equatable, Sendable {
  /// Coding keys for the SPDeveloperToolsDataType struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case spdevtoolsApps = "spdevtools_apps"
    case spdevtoolsPath = "spdevtools_path"
    case spdevtoolsSdks = "spdevtools_sdks"
    case spdevtoolsVersion = "spdevtools_version"
  }

  /// The name of the SP Developer Tools.
  public let name: String
  /// The SP Developer Tools apps.
  public let spdevtoolsApps: SpdevtoolsApps
  /// The path of the SP Developer Tools.
  public let spdevtoolsPath: String
  /// The SP Developer Tools SDKs.
  public let spdevtoolsSdks: SpdevtoolsSdks
  /// The version of the SP Developer Tools.
  public let spdevtoolsVersion: String

  /// Initializes a new instance of the SPDeveloperToolsDataType struct.
  ///
  /// - Parameters:
  ///   - name: The name of the SP Developer Tools.
  ///   - spdevtoolsApps: The SP Developer Tools apps.
  ///   - spdevtoolsPath: The path of the SP Developer Tools.
  ///   - spdevtoolsSdks: The SP Developer Tools SDKs.
  ///   - spdevtoolsVersion: The version of the SP Developer Tools.
  public init(
    name: String,
    spdevtoolsApps: SpdevtoolsApps,
    spdevtoolsPath: String,
    spdevtoolsSdks: SpdevtoolsSdks,
    spdevtoolsVersion: String
  ) {
    self.name = name
    self.spdevtoolsApps = spdevtoolsApps
    self.spdevtoolsPath = spdevtoolsPath
    self.spdevtoolsSdks = spdevtoolsSdks
    self.spdevtoolsVersion = spdevtoolsVersion
  }
}
