//
// NetworkConfiguration.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

public struct NetworkConfiguration: Codable, Identifiable {
  public init(id: UUID = .init(), attachment: NetworkingConfigurationAttachment) {
    self.id = id
    self.attachment = attachment
  }

  public let id: UUID
  public let attachment: NetworkingConfigurationAttachment
}
