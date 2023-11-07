//
// URL+Configuration.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public extension URL {
  struct Bushel {
    internal init(
      scheme: String,
      privacyPolicy: URL,
      termsOfUse: URL,
      support: URL,
      company: URL,
      contactMailTo: URL
    ) {
      self.scheme = scheme
      self.privacyPolicy = privacyPolicy
      self.termsOfUse = termsOfUse
      self.support = support
      self.company = company
      self.contactMailTo = contactMailTo
    }

    public let scheme: String

    public let privacyPolicy: URL
    public let termsOfUse: URL
    public let support: URL
    public let company: URL
    public let contactMailTo: URL

    private enum Key: String {
      case privacyPolicy
      case termsOfUse
      case support
      case company
      case contactMailTo
    }
  }

  static var bushel: Bushel {
    .shared
  }
}

extension URL.Bushel {
  // swiftlint:disable:next force_unwrapping strict_fileprivate
  fileprivate static let shared: URL.Bushel = .init()!

  init?(bundle: Bundle = .main) {
    guard let urlTypes = bundle.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]] else {
      return nil
    }
    guard let urlSchemes = urlTypes.first?["CFBundleURLSchemes"] as? [String] else {
      return nil
    }
    guard let scheme = urlSchemes.first else {
      return nil
    }
    guard let dictionary = bundle.object(
      forInfoDictionaryKey: "BrightDigitURLDirectory"
    ) as? [String: String] else {
      return nil
    }
    self.init(scheme: scheme, dictionary: dictionary)
  }

  init?(scheme: String, dictionary: [String: String]) {
    guard let privacyPolicy = dictionary[Key.privacyPolicy.rawValue].flatMap(URL.init(string:)) else {
      print("missing key \(Key.privacyPolicy)")
      return nil
    }

    guard let termsOfUse = dictionary[Key.termsOfUse.rawValue].flatMap(URL.init(string:)) else {
      print("missing key \(Key.termsOfUse)")
      return nil
    }

    guard let support = dictionary[Key.support.rawValue].flatMap(URL.init(string:)) else {
      print("missing key \(Key.support)")
      return nil
    }

    guard let company = dictionary[Key.company.rawValue].flatMap(URL.init(string:)) else {
      print("missing key \(Key.company)")
      return nil
    }

    guard let contactMailTo = dictionary[Key.contactMailTo.rawValue].flatMap(URL.init(string:)) else {
      print("missing key \(Key.contactMailTo)")
      return nil
    }

    self.init(
      scheme: scheme,
      privacyPolicy: privacyPolicy,
      termsOfUse: termsOfUse,
      support: support,
      company: company,
      contactMailTo: contactMailTo
    )
  }
}
