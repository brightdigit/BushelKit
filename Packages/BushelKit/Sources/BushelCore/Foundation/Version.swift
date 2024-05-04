//
// Version.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

#if canImport(os)
  import os.log
  public typealias Logger = os.Logger
#endif

/// Represents a version of an application, combining a semantic version with
/// a build number and an optional prerelease label.
public struct Version: CustomStringConvertible, Sendable {
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

  /// The semantic version component of this version.
  let marketingSemVer: Semver
  /// The build number associated with this version.
  let buildNumber: Int
  /// An optional prerelease label, indicating a non-release version.
  let prereleaseLabel: PrereleaseLabel?

  /// Creates a new `Version` instance with the provided components.
  internal init(marketingSemVer: Semver, buildNumber: Int, prereleaseLabel: PrereleaseLabel? = nil) {
    self.marketingSemVer = marketingSemVer
    self.buildNumber = buildNumber
    self.prereleaseLabel = prereleaseLabel
  }
}

public extension Version {
  #if canImport(os)
    nonisolated(unsafe) static let logger: Logger = .init(
      subsystem: Bundle.main.bundleIdentifier ?? "Bushel",
      category: "application"
    )
  #endif

  /// A formatted description of this version, suitable for display.
  var description: String {
    guard let prereleaseLabel else {
      return self.marketingSemVer.description
    }

    return "\(self.marketingSemVer) \(prereleaseLabel.label) \(buildNumber - prereleaseLabel.baseNumber)"
  }

  /// Creates a new `Version` instance by parsing a marketing version string, build number string,
  /// and optional prerelease label.
  ///
  /// - Parameters:
  ///   - marketingVersionText: The marketing version string (e.g., "1.2.3").
  ///   - buildNumberString: The build number string (e.g., "10").
  ///   - prereleaseLabel: An optional prerelease label (e.g., "beta-1").
  /// - Returns: A new `Version` instance if parsing is successful, otherwise nil.
  init?(marketingVersionText: String, buildNumberString: String, prereleaseLabel: PrereleaseLabel? = nil) {
    let marketingSemVer: Semver
    do {
      marketingSemVer = try Semver(string: marketingVersionText)
    } catch {
      assertionFailure(error: error)
      return nil
    }

    guard let buildNumber = Int(buildNumberString) else {
      #if canImport(os)
        Self.logger.critical("Invalid build number \(buildNumberString)")
      #endif
      assertionFailure()
      return nil
    }

    self.init(
      marketingSemVer: marketingSemVer,
      buildNumber: buildNumber,
      prereleaseLabel: prereleaseLabel
    )
  }

  /// Creates a new `Version` instance by reading information from the bundle's Info.plist dictionary.
  ///
  /// This initializer attempts to retrieve the marketing version, build number, and prerelease information
  /// (if available) from the bundle's Info.plist dictionary using known keys. If any required information
  /// is missing or invalid, it logs a critical error message and returns nil.
  ///
  /// - Parameter bundle: The bundle to read information from (defaults to the main bundle).
  /// - Returns: A new `Version` instance if information is successfully retrieved, otherwise nil.
  init?(bundle: Bundle = .main) {
    self.init(objectForInfoDictionaryKey: bundle.object(forInfoDictionaryKey:))
  }

  /// Creates a new `Version` instance by providing a custom function to retrieve
  /// values from the Info.plist dictionary.
  ///
  /// This initializer allows for more flexibility in how information is retrieved
  /// from the Info.plist dictionary. You can provide a function that takes a key
  /// value (as a string) and returns the corresponding value from the dictionary.
  /// This can be useful if you need to handle custom keys or have specific logic
  /// for retrieving values.
  ///
  /// - Parameter objectForInfoDictionaryKey: A function that takes a key value (as a string)
  ///   and returns the corresponding value from the Info.plist dictionary.
  /// - Returns: A new `Version` instance if information is successfully retrieved, otherwise nil.
  init?(objectForInfoDictionaryKey: @escaping (String) -> Any?) {
    self.init { key in
      objectForInfoDictionaryKey(key.value)
    }
  }

  private init?(objectForInfoDictionaryKey: @escaping (Key) -> Any?) {
    guard
      let marketingVersionText = objectForInfoDictionaryKey(.marketingVersion) as? String else {
      #if canImport(os)
        Self.logger.critical("Missing Marketing Version \(Key.marketingVersion.rawValue)")
      #endif
      return nil
    }

    guard
      let buildNumberString = objectForInfoDictionaryKey(.bundleVersion) as? String else {
      #if canImport(os)
        Self.logger.critical("Missing Bundle Version \(Key.bundleVersion.rawValue)")
      #endif
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

  /// Creates a hexadecimal string representing the build number, optionally
  /// padded to a specified length.
  ///
  /// - Parameter length: The desired length of the hexadecimal string.
  ///                     If omitted, no padding is applied.
  /// - Returns: A hexadecimal string representing the build number.
  func buildNumberHex(withLength length: Int? = 8) -> String {
    let hexString = String(buildNumber, radix: 16)
    guard let length else {
      return hexString
    }
    return String(String(repeating: "0", count: length).appending(hexString).suffix(length))
  }
}

public extension Bundle {
  /// Accesses the application version from the main bundle.
  // swiftlint:disable:next force_unwrapping
  static let applicationVersion: Version = Bundle.main.version!
  /// Accesses a formatted representation of the application version.
  static let applicationVersionFormatted: VersionFormatted = .init(version: Bundle.applicationVersion)

  /// Retrieves a `Version` instance for this bundle, if available.
  var version: Version? {
    .init(bundle: self)
  }

  /// Retrieves the name of the XPC service associated with this bundle, if available.
  var xpcService: String? {
    self.object(forInfoDictionaryKey: "BrightDigitXPCService") as? String
  }
}
