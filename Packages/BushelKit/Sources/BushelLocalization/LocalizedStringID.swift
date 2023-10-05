//
// LocalizedStringID.swift
// Copyright (c) 2023 BrightDigit.
//

public enum LocalizedStringID: String, CaseIterable, LocalizedID {
  case welcomeToBushel
  case upgradePurchase
  case proFeatures
  case aboutSubscriptionEndsAt
  case aboutFeedback
  case aboutFeedbackDetails
  case copyrightBrightdigit
  case version
  case name
  // swiftlint:disable:next identifier_name
  case ok
  case startMachine
  case snapshotMachine
  case buildMachine
  case downloading
  case download
  case cancel
  case importImage
  case downloadImage
  case selectImage
  case saveToLibrary
  case creatingSession
  case generalSettings
  case advancedSettings
  case restorePurchases
  case termsOfUse
  case privacyPolicy
  case stayBasic
  case menuNew
  case menuOpen
  case menuOpenRecent
  case menuWindowWelcomeToBushel
  case menuHelpBushel
  case menuClear
  case welcomePro
  case welcomeNewMachineTitle
  case welcomeExistingMachineTitle
  case welcomeStartLibraryTitle
  case welcomeNoRecentDocuments
  case welcomeUpdatingRecentDocuments
  case machineWillInstall
  case machineDetailsSystemTab
  case machineDetailsOS
  case machineDetailsChip
  case machineDetailsCPUName
  case machineDetailsCPUCount
  case machineDetailsMemoryName
  case machineDetailsMemorySize
  case machineDetailsStorageName
  case machineDetailsStorageSize
  case machineDetailsDisplay
  case machineDetailsNetworkName
  case machineDetailsNetworkNat
  case hubImageSize
  case hubLastModified
  case hubURL
  case hubNoneSelected
  case sessionPressPowerButton
  case sessionSaveAndTurnOff
  case sessionTurnOff
  case sessionShutdownAlert
  case settingsGeneralTab
  case settingsAdvancedTab
  case settingsTestTab
  case settingsAboutTab
  case databaseBookmarks
  case databaseLibraries
  case databaseImages
  case databaseMachines
  case databaseSnapshots
  case operationProgressText
  case machineOperationSnapshotRestoring
  case machineOperationSnapshotExporting
  case machineOperationSnapshotSaving

  public var keyValue: String {
    rawValue.camelCaseTosnake_case()
  }
}
