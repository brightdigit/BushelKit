//
//  VirtualBuddyConfiguration.swift
//  BushelKit
//
//  Created by Leo Dion on 11/8/24.
//

public import Foundation

public struct VirtualBuddyConfiguration: Sendable {
  enum Keys: String {
    case virtualBuddy = "VirtualBuddy"
    case apiKey = "APIKey"
  }

  public static let main: VirtualBuddyConfiguration? = .init()
  public let apiKey: String
}

extension VirtualBuddyConfiguration {
  public init?(bundle: Bundle = .main) {
    guard let dictionary = bundle.object(
      forInfoDictionaryKey: Keys.virtualBuddy.rawValue
    ) as? [String: String] else {
      return nil
    }

    guard let apiKey = dictionary[Keys.apiKey.rawValue] else {
      return nil
    }

    self.init(apiKey: apiKey)
  }
}
