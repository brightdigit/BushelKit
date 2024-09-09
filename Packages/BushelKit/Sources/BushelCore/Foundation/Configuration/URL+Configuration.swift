//
//  URL+Configuration.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

extension URL {
  public struct Bushel: Sendable {
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

    public let paths = Paths()

    private enum Key: String {
      case privacyPolicy
      case termsOfUse
      case support
      case company
      case contactMailTo
    }
  }

  public static var bushel: Bushel {
    .shared
  }
}

public protocol VZMacPaths: Sendable {
  var hardwareModelFileName: String { get }
  var machineIdentifierFileName: String { get }
  var auxiliaryStorageFileName: String { get }
}

extension URL.Bushel {
  public struct Paths: Sendable {
    public typealias VZMac = VZMacPaths
    public let restoreImagesDirectoryName = Defaults.restoreImagesDirectoryName
    public let machineDataDirectoryName = Defaults.machineDataDirectoryName
    public let snapshotsDirectoryName = Defaults.snapshotsDirectoryName
    public let machineJSONFileName = Defaults.machineJSONFileName
    public let restoreLibraryJSONFileName = Defaults.restoreLibraryJSONFileName
    private enum Defaults {
      fileprivate static let restoreImagesDirectoryName = "Restore Images"
      fileprivate static let machineDataDirectoryName = "data"
      fileprivate static let snapshotsDirectoryName = "snapshots"
      fileprivate static let machineJSONFileName = "machine.json"
      fileprivate static let restoreLibraryJSONFileName = "metadata.json"
    }
  }

  // swiftlint:disable:next force_unwrapping strict_fileprivate
  fileprivate static let shared: URL.Bushel = .init()!

  private init?(bundle: Bundle = .main) {
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

  private init?(scheme: String, dictionary: [String: String]) {
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
