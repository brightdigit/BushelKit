//
// Configuration.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/28/22.
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

  static let prereleaseLabel: String? = "alpha"

  static let applicationMarketingVersionValue: String = Bundle.main.object(forInfoDictionaryKey: cfBundleShortVersionString) as! String

  static let applicationMarketingVersionText: String = {
    guard let prereleaseLabel = prereleaseLabel else {
      return applicationMarketingVersionValue
    }

    return "\(applicationMarketingVersionValue) \(prereleaseLabel) \(applicationBuildNumber)"
  }()

  static let applicationBuildString: String = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String

  static let applicationBuildNumber: Int = .init(applicationBuildString)!

  static let applicationBuildFormatted: String = {
    var hexString = String(applicationBuildNumber, radix: 16)
    return String(String(repeating: "0", count: 8).appending(hexString).suffix(8))
  }()
}
