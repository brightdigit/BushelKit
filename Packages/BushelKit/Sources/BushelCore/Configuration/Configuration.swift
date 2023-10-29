//
// Configuration.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum Configuration {
  @available(*, deprecated, renamed: "URL.bushel", message: "Use URL.bushel")
  public enum URLs {
    public static let privacyPolicy: URL = .bushel.privacyPolicy
    public static let termsOfUse: URL = .bushel.termsOfUse
    public static let support: URL = .bushel.support
  }

  public enum Defaults {
    public static let encoder: JSONEncoder = {
      let value = JSONEncoder()
      return value
    }()

    static let decoder: JSONDecoder = {
      let value = JSONDecoder()
      return value
    }()
  }

  static let scheme = "bushel"

  static let baseURLComponents: URLComponents = {
    var components = URLComponents()
    components.scheme = Self.scheme
    return components
  }()

  // swiftlint:disable:next force_unwrapping
  public static let version: Version = .init()!

  public static let versionFormatted: VersionFormatted = .init(version: Self.version)
}
