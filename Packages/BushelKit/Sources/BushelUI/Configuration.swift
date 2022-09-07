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

  // swiftlint:disable:next force_cast
  static let applicationMarketingVersionValue: String = Bundle.main.object(forInfoDictionaryKey: cfBundleShortVersionString) as! String

  static let applicationMarketingVersionText: String = {
    guard let prereleaseLabel = prereleaseLabel else {
      return applicationMarketingVersionValue
    }

    return "\(applicationMarketingVersionValue) \(prereleaseLabel) \(applicationBuildNumber)"
  }()

  // swiftlint:disable:next force_cast
  static let applicationBuildString: String = Bundle.main.object(forInfoDictionaryKey: bundleVersionKey) as! String

  static let applicationBuildNumber: Int = .init(applicationBuildString)!

  static let applicationBuildFormatted: String = {
    var hexString = String(applicationBuildNumber, radix: 16)
    return String(String(repeating: "0", count: 8).appending(hexString).suffix(8))
  }()

  enum URLs {
    static let privacyPolicy: URL = .init(string: "https://getbushel.app/privacy-policy")!
    static let termsOfUse: URL = .init(string: "https://getbushel.app/terms-of-use")!
    static let support: URL = .init(string: "https://getbushel.app/support")!
  }
}
