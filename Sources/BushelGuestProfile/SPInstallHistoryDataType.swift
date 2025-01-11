//
//  SPInstallHistoryDataType.swift
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

/// Represents the data type for the install history of a package.
public struct SPInstallHistoryDataType: Codable, Equatable, Sendable {
  /// The coding keys for the `SPInstallHistoryDataType` struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case installDate = "install_date"
    case installVersion = "install_version"
    case packageSource = "package_source"
  }

  /// The name of the installed package.
  public let name: String
  /// The date the package was installed.
  public let installDate: Date
  /// The version of the installed package.
  public let installVersion: String
  /// The source of the installed package.
  public let packageSource: PackageSource

  /// Initializes an `SPInstallHistoryDataType` instance.
  ///
  /// - Parameters:
  ///   - name: The name of the installed package.
  ///   - installDate: The date the package was installed.
  ///   - installVersion: The version of the installed package.
  ///   - packageSource: The source of the installed package.
  public init(
    name: String,
    installDate: Date,
    installVersion: String,
    packageSource: PackageSource
  ) {
    self.name = name
    self.installDate = installDate
    self.installVersion = installVersion
    self.packageSource = packageSource
  }
}
