//
//  Proxies.swift
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

/// Represents a collection of proxy settings.
public struct Proxies: Codable, Equatable, Sendable {
  /// The coding keys for the `Proxies` struct.
  public enum CodingKeys: String, CodingKey {
    case exceptionsList = "ExceptionsList"
    case ftpPassive = "FTPPassive"
  }

  /// A list of exceptions for the proxy settings.
  public let exceptionsList: [String]

  /// The FTP passive mode setting.
  public let ftpPassive: PrivateFramework

  /// Initializes a new instance of the `Proxies` struct.
  /// - Parameters:
  ///   - exceptionsList: The list of exceptions for the proxy settings.
  ///   - ftpPassive: The FTP passive mode setting.
  public init(exceptionsList: [String], ftpPassive: PrivateFramework) {
    self.exceptionsList = exceptionsList
    self.ftpPassive = ftpPassive
  }
}
