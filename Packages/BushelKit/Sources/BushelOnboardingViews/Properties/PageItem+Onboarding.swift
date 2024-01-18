//
// PageItem+Onboarding.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelLocalization

extension PageItem {
  static let welcome = PageItem(
    titleID: .onboardingWelcomeTitle,
    subtitleID: .onboardingWelcomeSubtitle,
    messageID: .onboardingWelcomeMessage,
    videoResourceName: "onboarding-welcome"
  )
  static let library = PageItem(
    titleID: .onboardingLibraryTitle,
    subtitleID: .onboardingLibrarySubtitle,
    messageID: .onboardingLibraryMessage,
    videoResourceName: "onboarding-library"
  )

  static let hub = PageItem(
    titleID: .onboardingHubTitle,
    subtitleID: .onboardingHubSubtitle,
    messageID: .onboardingHubMessage,
    videoResourceName: "onboarding-hub"
  )

  static let machine = PageItem(
    titleID: .onboardingMachineTitle,
    subtitleID: .onboardingMachineSubtitle,
    messageID: .onboardingMachineMessage,
    videoResourceName: "onboarding-machine"
  )

  static let snapshots = PageItem(
    titleID: .onboardingSnapshotsTitle,
    subtitleID: .onboardingSnapshotsSubtitle,
    messageID: .onboardingSnapshotsMessage,
    videoResourceName: "onboarding-snapshot"
  )
  static let done = PageItem(
    titleID: .onboardingDoneTitle,
    subtitleID: .onboardingDoneSubtitle,
    messageID: .onboardingDoneMessage,
    videoResourceName: "onboarding-done"
  )
}
