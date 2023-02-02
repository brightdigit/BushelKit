//
// UserDefaults.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
#if canImport(os)
  import os
#else
  import Logging
#endif

public extension UserDefaults {
  func decode<T: Decodable>(
    using decoder: JSONDecoder,
    withKey key: UserDefaultsKey,
    logger: Logger,
    override: [T]? = nil,
    defaultValue: [T] = .init()
  ) -> [T] {
    if let images = override {
      return images
    } else if let data = data(forKey: key.rawValue) {
      do {
        return try decoder.decode([T].self, from: data)
      } catch {
        logger.error(
          "couldn't decode UserDefault for \(key.rawValue): \(error.localizedDescription)"
        )
        return defaultValue
      }
    } else {
      return defaultValue
    }
  }

  func setData(_ userDefaultsData: UserDefaultData) {
    set(userDefaultsData.data, forKey: userDefaultsData.key.rawValue)
  }
}
