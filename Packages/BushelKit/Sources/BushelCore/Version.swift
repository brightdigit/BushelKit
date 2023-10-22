//
// Version.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct Version: CustomStringConvertible {
  private enum Key: String {
    case marketingVersion = "CFBundleShortVersionString"
    case bundleVersion = "CFBundleVersion"
    case prelease = "BrightDigitPrereleaseInfo"

    var value: String {
      #if !os(Linux)
        if self == .bundleVersion {
          return kCFBundleVersionKey as String
        }
      #endif
      return rawValue
    }
  }

  let marketingSemVer: Semver
  let buildNumber: Int
  let prereleaseLabel: PrereleaseLabel?

  internal init(marketingSemVer: Semver, buildNumber: Int, prereleaseLabel: PrereleaseLabel? = nil) {
    self.marketingSemVer = marketingSemVer
    self.buildNumber = buildNumber
    self.prereleaseLabel = prereleaseLabel
  }
}

public extension Version {
  var description: String {
    guard let prereleaseLabel else {
      return self.marketingSemVer.description
    }

    return "\(self.marketingSemVer) \(prereleaseLabel.label) \(buildNumber - prereleaseLabel.baseNumber)"
  }

  init?(marketingVersionText: String, buildNumberString: String, prereleaseLabel: PrereleaseLabel? = nil) {
    let marketingSemVer: Semver
    do {
      marketingSemVer = try Semver(string: marketingVersionText)
    } catch {
      assertionFailure(error: error)
      return nil
    }

    guard let buildNumber = Int(buildNumberString) else {
      #warning("logging-note: let's have a message here about what was expected")
      assertionFailure()
      return nil
    }

    self.init(
      marketingSemVer: marketingSemVer,
      buildNumber: buildNumber,
      prereleaseLabel: prereleaseLabel
    )
  }

  init?(bundle: Bundle = .main) {
    self.init(objectForInfoDictionaryKey: bundle.object(forInfoDictionaryKey:))
  }

  #warning("logging-note: let's log message for each else of guard statement")
  private init?(objectForInfoDictionaryKey: @escaping (Key) -> Any?) {
    guard
      let marketingVersionText = objectForInfoDictionaryKey(.marketingVersion) as? String else {
      return nil
    }

    guard
      let buildNumberString = objectForInfoDictionaryKey(.bundleVersion) as? String else {
      return nil
    }

    let prereleaseLabel: PrereleaseLabel?
    if let prereleaseDictionary = objectForInfoDictionaryKey(.prelease) as? [String: Any] {
      prereleaseLabel = .init(dictionary: prereleaseDictionary)
    } else {
      prereleaseLabel = nil
    }

    self.init(
      marketingVersionText: marketingVersionText,
      buildNumberString: buildNumberString,
      prereleaseLabel: prereleaseLabel
    )
  }

  init?(objectForInfoDictionaryKey: @escaping (String) -> Any?) {
    self.init { key in
      objectForInfoDictionaryKey(key.value)
    }
  }

  func buildNumberHex(withLength length: Int? = 8) -> String {
    let hexString = String(buildNumber, radix: 16)
    guard let length else {
      #warning("logging-note: not sure what guard-else mean, but can we log some message here?")
      return hexString
    }
    return String(String(repeating: "0", count: length).appending(hexString).suffix(length))
  }
}
