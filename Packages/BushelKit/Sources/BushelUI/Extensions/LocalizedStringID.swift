//
// LocalizedStringID.swift
// Copyright (c) 2022 BrightDigit.
//

enum LocalizedStringID: String {
  case welcomeToBushel
  case remoteRestoreImages
  case loadingMachine
  case upgradePurchase
  case proFeatures
  case version
  case savingMachine
  case startMachine
  case buildMachine
  case buildingMachine
  case installingOs
  case importFirstImage
  case importRestoreImage
  case selectRestoreImage
  case downloading
  case cancel
  case importImage
  case downloadImage
  case saveToIpsw
  case saveToLibrary
  case creatingSession
  case generalSettings
  case advancedSettings
  case restorePurchases
  case termsOfUse
  case privacyPolicy
  case stayBasic
  case menuNew
  case menuNewMachine
  case menuNewImageLibrary
  case menuOpenRecent
  case menuNewDownloadRestoreImage
  case menuWindowWelcomeToBushel
  case menuHelpBushel
  case welcomeNewMachineTitle
  case welcomeNewMachineDescription
  case welcomeExistingMachineTitle
  case welcomeExistingMachineDescription
  case welcomeStartLibraryTitle
  case welcomeStartLibraryDescription
  case welcomeDownloadImageTitle
  case welcomeDownloadImageDescription

  var keyValue: String {
    rawValue.camelCaseTosnake_case()
  }
}

#if canImport(SwiftUI)
  import SwiftUI

  extension LocalizedStringID {
    var key: LocalizedStringKey {
      LocalizedStringKey(keyValue)
    }
  }
#endif