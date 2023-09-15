//
// NetworkConfiguration.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct NetworkConfiguration: Codable, Identifiable {
  public let id: UUID
  public let attachment: NetworkingConfigurationAttachment
  // swiftlint:disable:next function_default_parameter_at_end
  public init(id: UUID = .init(), attachment: NetworkingConfigurationAttachment) {
    self.id = id
    self.attachment = attachment
  }
}

public extension NetworkConfiguration {
  static func `default`() -> NetworkConfiguration { .init(attachment: .nat)
  }
}
