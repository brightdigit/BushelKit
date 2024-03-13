//
// SPInternationalDataType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

// MARK: - SPInternationalDataType

public struct SPInternationalDataType: Codable, Equatable, Sendable {
  enum CodingKeys: String, CodingKey {
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

  // swiftlint:disable:next line_length
  public init(name: String, linguisticDataAssetsRequested: [String]?, userCalendar: String?, userCountryCode: String?, userLanguageCode: String?, userLocale: String?, userPreferredInterfaceLanguages: [String]?, userUsesMetricSystem: String?, systemCountry: String?, systemInterfaceLanguages: [String]?, systemLanguages: [String]?, systemLocale: String?, systemTextDirection: String?, systemUsesMetricSystem: String?, bootKbd: String?, bootLocale: String?) {
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
