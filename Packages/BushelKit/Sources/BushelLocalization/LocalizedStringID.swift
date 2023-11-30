//
// LocalizedStringID.swift
// Copyright (c) 2023 BrightDigit.
//

public enum LocalizedStringID: String, CaseIterable, LocalizedID {
  // swiftlint:disable identifier_name
  case welcomeToBushel
  case upgradePurchase
  case proFeatures
  case aboutSubscriptionEndsAt
  case aboutFeedback
  case aboutFeedbackDetails
  case aboutAuthorCredits
  case aboutSocialHeader
  case copyrightBrightdigit
  case version
  case name
  case ok
  case contactUs
  case startMachine
  case openMachine
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
  case menuOnboarding
  case welcomePro
  case welcomeNewMachineTitle
  case welcomeExistingMachineTitle
  case welcomeStartLibraryTitle
  case welcomeNoRecentDocuments
  case welcomeUpdatingRecentDocuments
  case machineWillInstall
  case machineInstallErrorDelete
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
  case sessionForceRestartTitle
  case sessionForceRestartButton
  case sessionForceRestartMessage
  case sessionPressPowerButton
  case sessionUpgradeSaveAndTurnOff
  case sessionSaveAndTurnOff
  case sessionTurnOff
  case sessionShutdownAlert
  case sessionShutdownTitle
  case sessionCaptureSystemKeysToggle
  case sessionAutomaticallyReconfigureDisplayToggle
  case keepWindowOpenOnShutdown
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
  case machineConfirmDeleteYes
  case machineConfirmRestoreOverwrite
  case machineConfirmDeleteCancel
  case machineConfirmRestoreCancel
  case machineConfirmRestoreNew
  case onboardingWelcomeTitle
  case onboardingWelcomeSubtitle
  case onboardingWelcomeMessage
  case onboardingLibraryTitle
  case onboardingLibrarySubtitle
  case onboardingLibraryMessage
  case onboardingHubTitle
  case onboardingHubSubtitle
  case onboardingHubMessage
  case onboardingMachineTitle
  case onboardingMachineSubtitle
  case onboardingMachineMessage
  case onboardingSnapshotsTitle
  case onboardingSnapshotsSubtitle
  case onboardingSnapshotsMessage
  case onboardingDoneTitle
  case onboardingDoneSubtitle
  case onboardingDoneMessage
  case onboardingFeatureListHeader
  case onboardingFeatureItemLocalizationAndAccessibilityTitle
  case onboardingFeatureItemLocalizationAndAccessibilityDescription
  case onboardingFeatureItemSnapshotsTitle
  case onboardingFeatureItemSnapshotsDescription
  case onboardingFeatureItemScriptTitle
  case onboardingFeatureItemScriptDescription
  case onboardingFeatureItemCustomMachineTitle
  case onboardingFeatureItemCustomMachineDescription
  case onboardingFeatureItemRestoreImageManagementTitle
  case onboardingFeatureItemRestoreImageManagementDescription
  case onboardingFeatureItemVersionsTitle
  case onboardingFeatureItemVersionsDescription
  case onboardingFeatureItemLibraryTitle
  case onboardingFeatureItemLibraryDescription
  case onboardingDoneButton
  case onboardingNextButton
  case tipLibraryTitle
  case tipLibraryMessage
  case libraryDeleteConfirmation
  case libraryUnsupportedImage
  case snapshotDetailsPropertySize
  case snapshotDetailsPropertyDicardable
  case snapshotDetailsPropertyName
  case snapshotDetailsPropertyNotes
  case snapshotDetailsPropertyCreated
  case purchaseDescription
  case purchaseFeatureSnapshotNotesDescription
  case purchaseFeatureShutdownSnapshotDescription
  case purchaseFeatureAutomaticSnapshotsTitle
  case purchaseFeatureSnapshotNotesTitle
  case purchaseFeatureAutomaticSnapshotsDescription
  case purchaseFeatureShutdownSnapshotTitle
  case settingsClearDatabaseLabel
  case settingsSessionCloseForceTurnOff
  case settingsAutomaticSnapshotsDescription
  case settingsResetAllConfirmationTitle
  case settingsAutomaticSnapshotsOften
  case settingsFilterRecentDocuments
  case settingsFilterRecentDocumentsMachinesOnly
  case settingsFilterRecentDocumentsNone
  case settingsClearAllRecentDocuments
  case settingsClearDatabaseConfirmationTitle
  case settingsClearDatabaseConfirmationButton
  case settingsDatabaseShowTitle
  case settingsDatabaseShowButton
  case settingsSessionCloseButton
  case settingsMachineShutdownAlwaysClose
  case settingsResetUserSettingsDescription
  case settingsResetAllLabel
  case settingsAutomaticSnapshotsMin
  case recentDocuments
  case settingsClearRecentDocuments
  case settingsSessionCloseSaveSnapshotTurnOff
  case settingsResetUserSettingsConfirmationButton
  case enabled
  case upgradeTo
  case settingsResetUserSettingsConfirmationTitle
  case settingsClearDatabaseDescription
  case settingsAutomaticSnapshotsPrefix
  case settingsAutomaticSnapshotsSection
  case settingsSessionCloseAskUser
  case settingsResetAllDescription
  case settingsAutomaticSnapshotsMax
  case settingsSessionCloseLabel
  case settingsAutomaticSnapshotsLabel
  case settingsActiveSession
  case settingsResetAllConfirmationButton
  case settingsResetUserSettingsLabel
  case settingsMachineShutdown
  // swiftlint:enable identifier_name
  public var keyValue: String {
    rawValue.camelCaseTosnake_case()
  }
}
