//
// Configuration.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum Configuration {
  enum URLs {
    static let privacyPolicy: URL = .init("https://getbushel.app/privacy-policy")
    static let termsOfUse: URL = .init("https://getbushel.app/terms-of-use")
    static let support: URL = .init("https://getbushel.app/support")
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

public extension Configuration {
  enum Marketplace {
    #warning("Put this in a plist")
    public static let groupID = "21016280"
  }
}
