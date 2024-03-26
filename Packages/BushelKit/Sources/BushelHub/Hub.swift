//
// Hub.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import Foundation

public struct Hub: Hashable, Identifiable {
  public let title: String
  public let id: String
  public let count: Int?
  public let getImages: () async throws -> [HubImage]

  public init(title: String, id: String, count: Int?, _ images: @escaping () async throws -> [HubImage]) {
    self.title = title
    self.id = id
    self.count = count
    self.getImages = images
  }

  public static func == (lhs: Hub, rhs: Hub) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}
