//
// Bundle.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

private enum WishKitKeys: String {
  case wishKit = "WishKit"
  case apiKey = "APIKey"
}

extension Bundle {
  internal var wishKitConfiguration: WishKitConfiguration? {
    guard let object = self.object(forInfoDictionaryKey: WishKitKeys.wishKit.rawValue) else {
      return nil
    }
    return .init(object: object)
  }
}

extension WishKitConfiguration {
  fileprivate init?(object: Any) {
    guard let dictionary = object as? [String: String] else {
      return nil
    }
    self.init(dictionary: dictionary)
  }

  fileprivate init?(dictionary: [String: String]) {
    guard let apiKey = dictionary[WishKitKeys.apiKey.rawValue] else {
      return nil
    }
    self.init(apiKey: apiKey)
  }
}
