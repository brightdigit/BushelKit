//
// URL+Configuration.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public extension URL {
  static let bushel: Bushel = .init()!
  struct Bushel {
    internal init(privacyPolicy: URL, termsOfUse: URL, support: URL) {
      self.privacyPolicy = privacyPolicy
      self.termsOfUse = termsOfUse
      self.support = support
    }

    public let privacyPolicy: URL
    public let termsOfUse: URL
    public let support: URL
    private enum Key: String {
      case privacyPolicy
      case termsOfUse
      case support
    }
  }
}

extension URL.Bushel {
  init?(bundle: Bundle = .main) {
    guard let dictionary = bundle.object(forInfoDictionaryKey: "BrightDigitURLDirectory") as? [String: String] else {
      return nil
    }
    self.init(dictionary: dictionary)
  }

  init?(dictionary: [String: String]) {
    guard let privacyPolicy = dictionary[Key.privacyPolicy.rawValue].flatMap(URL.init(string:)) else {
      return nil
    }

    guard let termsOfUse = dictionary[Key.termsOfUse.rawValue].flatMap(URL.init(string:)) else {
      return nil
    }

    guard let support = dictionary[Key.support.rawValue].flatMap(URL.init(string:)) else {
      return nil
    }

    self.init(privacyPolicy: privacyPolicy, termsOfUse: termsOfUse, support: support)
  }
}
