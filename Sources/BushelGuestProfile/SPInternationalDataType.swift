//
//  SPInternationalDataType.swift
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

/// A struct that represents international data types.
public struct SPInternationalDataType: Codable, Equatable, Sendable {
  /// The keys used for coding and decoding the struct.
  public enum CodingKeys: String, CodingKey {
    case name = "_name"
    case linguisticDataAssetsRequested = "linguistic_data_assets_requested"
    case userCalendar = "user_calendar"
    case userCountryCode = "user_country_code"
    case userLanguageCode = "user_language_code"
    case userLocale = "user_locale"
    case userPreferredInterfaceLanguages = "user_preferred_interface_languages"
    case userUsesMetricSystem = "user_uses_metric_system"
    case systemCountry = "system_country"
    case systemInterfaceLanguages = "system_interface_languages"
    case systemLanguages = "system_languages"
    case systemLocale = "system_locale"
    case systemTextDirection = "system_text_direction"
    case systemUsesMetricSystem = "system_uses_metric_system"
    case bootKbd = "boot_kbd"
    case bootLocale = "boot_locale"
  }

  /// The name of the international data type.
  public let name: String
  /// The linguistic data assets requested.
  public let linguisticDataAssetsRequested: [String]?
  /// The user's calendar.
  public let userCalendar: String?
  /// The user's country code.
  public let userCountryCode: String?
  /// The user's language code.
  public let userLanguageCode: String?
  /// The user's locale.
  public let userLocale: String?
  /// The user's preferred interface languages.
  public let userPreferredInterfaceLanguages: [String]?
  /// Whether the user uses the metric system.
  public let userUsesMetricSystem: String?
  /// The system's country.
  public let systemCountry: String?
  /// The system's interface languages.
  public let systemInterfaceLanguages: [String]?
  /// The system's languages.
  public let systemLanguages: [String]?
  /// The system's locale.
  public let systemLocale: String?
  /// The system's text direction.
  public let systemTextDirection: String?
  /// Whether the system uses the metric system.
  public let systemUsesMetricSystem: String?
  /// The boot keyboard.
  public let bootKbd: String?
  /// The boot locale.
  public let bootLocale: String?

  /// Initializes a new `SPInternationalDataType` instance.
  /// - Parameters:
  ///   - name: The name of the international data type.
  ///   - linguisticDataAssetsRequested: The linguistic data assets requested.
  ///   - userCalendar: The user's calendar.
  ///   - userCountryCode: The user's country code.
  ///   - userLanguageCode: The user's language code.
  ///   - userLocale: The user's locale.
  ///   - userPreferredInterfaceLanguages: The user's preferred interface languages.
  ///   - userUsesMetricSystem: Whether the user uses the metric system.
  ///   - systemCountry: The system's country.
  ///   - systemInterfaceLanguages: The system's interface languages.
  ///   - systemLanguages: The system's languages.
  ///   - systemLocale: The system's locale.
  ///   - systemTextDirection: The system's text direction.
  ///   - systemUsesMetricSystem: Whether the system uses the metric system.
  ///   - bootKbd: The boot keyboard.
  ///   - bootLocale: The boot locale.
  public init(
    name: String,
    linguisticDataAssetsRequested: [String]?,
    userCalendar: String?,
    userCountryCode: String?,
    userLanguageCode: String?,
    userLocale: String?,
    userPreferredInterfaceLanguages: [String]?,
    userUsesMetricSystem: String?,
    systemCountry: String?,
    systemInterfaceLanguages: [String]?,
    systemLanguages: [String]?,
    systemLocale: String?,
    systemTextDirection: String?,
    systemUsesMetricSystem: String?,
    bootKbd: String?,
    bootLocale: String?
  ) {
    self.name = name
    self.linguisticDataAssetsRequested = linguisticDataAssetsRequested
    self.userCalendar = userCalendar
    self.userCountryCode = userCountryCode
    self.userLanguageCode = userLanguageCode
    self.userLocale = userLocale
    self.userPreferredInterfaceLanguages = userPreferredInterfaceLanguages
    self.userUsesMetricSystem = userUsesMetricSystem
    self.systemCountry = systemCountry
    self.systemInterfaceLanguages = systemInterfaceLanguages
    self.systemLanguages = systemLanguages
    self.systemLocale = systemLocale
    self.systemTextDirection = systemTextDirection
    self.systemUsesMetricSystem = systemUsesMetricSystem
    self.bootKbd = bootKbd
    self.bootLocale = bootLocale
  }
}
