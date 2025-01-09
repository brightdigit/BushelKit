//
//  NetworkConfiguration.swift
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

/// Represents a network configuration with an associated attachment.
public struct NetworkConfiguration: Codable, Identifiable, Sendable {
  /// A unique identifier for the network configuration.
  public let id: UUID

  /// The attachment associated with the network configuration.
  public let attachment: NetworkingConfigurationAttachment

  /// Initializes a new `NetworkConfiguration` with the specified attachment.
  ///
  /// - Parameter id: A unique identifier for the network configuration.
  /// If not provided, a new `UUID` will be generated.
  /// - Parameter attachment: The attachment associated with the network configuration.
  public init(id: UUID = .init(), attachment: NetworkingConfigurationAttachment) {
    self.id = id
    self.attachment = attachment
  }
}

extension NetworkConfiguration {
  /// Returns the default `NetworkConfiguration` with a `.nat` attachment.
  ///
  /// - Returns: The default `NetworkConfiguration`.
  public static func `default`() -> NetworkConfiguration {
    .init(attachment: .nat)
  }
}
