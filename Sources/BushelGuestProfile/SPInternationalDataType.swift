//
//  SPInternationalDataType.swift
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

public import Foundation

// MARK: - SPInternationalDataType

public struct SPInternationalDataType: Codable, Equatable, Sendable {
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

  public let name: String
  public let linguisticDataAssetsRequested: [String]?
  public let userCalendar: String?
  public let userCountryCode: String?
  public let userLanguageCode: String?
  public let userLocale: String?
  public let userPreferredInterfaceLanguages: [String]?
  public let userUsesMetricSystem: String?
  public let systemCountry: String?
  public let systemInterfaceLanguages: [String]?
  public let systemLanguages: [String]?
  public let systemLocale: String?
  public let systemTextDirection: String?
  public let systemUsesMetricSystem: String?
  public let bootKbd: String?
  public let bootLocale: String?

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
