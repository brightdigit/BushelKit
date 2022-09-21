//
// Configuration.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation

enum Configuration {
  static let scheme = "bushel"
  static let cfBundleShortVersionString = "CFBundleShortVersionString"
  static let baseURLComponents: URLComponents = {
    var components = URLComponents()
    components.scheme = Self.scheme
    return components
  }()

  #if os(Linux)
    static let bundleVersionKey: String = "CFBundleVersion"
  #else

    static let bundleVersionKey: String = kCFBundleVersionKey as String

  #endif

  static let prereleaseLabel: String? = "alpha"

  static let applicationMarketingVersionValue = Bundle.main
    // swiftlint:disable:next force_cast
    .object(forInfoDictionaryKey: cfBundleShortVersionString) as! String

  static let applicationMarketingVersionText: String = {
    guard let prereleaseLabel = prereleaseLabel else {
      return applicationMarketingVersionValue
    }

    return "\(applicationMarketingVersionValue) \(prereleaseLabel) \(applicationBuildNumber)"
  }()

  static let applicationBuildString: String = Bundle.main
    // swiftlint:disable:next force_cast
    .object(forInfoDictionaryKey: bundleVersionKey) as! String

  // swiftlint:disable:next force_unwrapping
  static let applicationBuildNumber: Int = .init(applicationBuildString)!

  static let applicationBuildFormatted: String = {
    var hexString = String(applicationBuildNumber, radix: 16)
    return String(String(repeating: "0", count: 8).appending(hexString).suffix(8))
  }()

  enum URLs {
    static let privacyPolicy: URL = .init("https://getbushel.app/privacy-policy")
    static let termsOfUse: URL = .init("https://getbushel.app/terms-of-use")
    static let support: URL = .init("https://getbushel.app/support")
  }
}
