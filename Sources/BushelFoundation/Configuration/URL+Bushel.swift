//
//  URL+Bushel.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

public import Foundation

extension URL {
  /// A struct that encapsulates various URLs related to
  /// an app's privacy policy, terms of use, support, company, and contact information.
  public struct Bushel: Sendable {
    private enum Key: String {
      case privacyPolicy
      case termsOfUse
      case support
      case company
      case contactMailTo
    }

    /// The URL scheme associated with the app.
    public let scheme: String

    /// The URL for the app's privacy policy.
    public let privacyPolicy: URL
    /// The URL for the app's terms of use.
    public let termsOfUse: URL
    /// The URL for the app's support website.
    public let support: URL
    /// The URL for the app's company website.
    public let company: URL
    /// The URL for the app's contact email.
    public let contactMailTo: URL

    /// A struct that contains various file and directory paths used by the app.
    public let paths = Paths()
    /// Initializes a new `Bushel` instance with the provided parameters.
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
  }

  /// A shared instance of the `URL.Bushel` struct.
  public static var bushel: Bushel {
    .shared
  }
}

extension URL.Bushel {
  // swiftlint:disable force_unwrapping
  /// A shared instance of the `URL.Bushel` struct.
  fileprivate static let shared: URL.Bushel = .init()!
  // swiftlint:enable force_unwrapping

  /// Initializes a new `URL.Bushel` instance from the app's Info.plist file.
  ///
  /// - Parameter bundle: The bundle from which to retrieve the URL information. Defaults to `.main`.
  private init?(bundle: Bundle = .main) {
    guard
      let urlTypes = bundle.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]],
      let urlSchemes = urlTypes.first?["CFBundleURLSchemes"] as? [String],
      let scheme = urlSchemes.first,
      let dictionary = bundle.object(forInfoDictionaryKey: "BrightDigitURLDirectory")
        as? [String: String]
    else {
      return nil
    }
    self.init(scheme: scheme, dictionary: dictionary)
  }

  /// Initializes a new `URL.Bushel` instance with the provided scheme and dictionary.
  ///
  /// - Parameters:
  ///   - scheme: The URL scheme.
  ///   - dictionary: A dictionary containing the URL information.
  private init?(scheme: String, dictionary: [String: String]) {
    guard let privacyPolicy = dictionary[Key.privacyPolicy.rawValue].flatMap(URL.init(string:))
    else {
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

    guard let contactMailTo = dictionary[Key.contactMailTo.rawValue].flatMap(URL.init(string:))
    else {
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
