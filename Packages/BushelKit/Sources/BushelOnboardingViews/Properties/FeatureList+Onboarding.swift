//
// FeatureList+Onboarding.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelLocalization

extension FeatureList {
  init() {
    self.init {
      FeatureItem(
        featureIcon: .localizationAndAccessibility,
        titleID: .onboardingFeatureItemLocalizationAndAccessibilityTitle,
        descriptionID: .onboardingFeatureItemLocalizationAndAccessibilityDescription
      )
      FeatureItem(
        featureIcon: .snapshots,
        titleID: .onboardingFeatureItemSnapshotsTitle,
        descriptionID: .onboardingFeatureItemSnapshotsDescription
      )
      FeatureItem(
        featureIcon: .script,
        titleID: .onboardingFeatureItemScriptTitle,
        descriptionID: .onboardingFeatureItemScriptDescription
      )
      FeatureItem(
        featureIcon: .customMachine,
        titleID: .onboardingFeatureItemCustomMachineTitle,
        descriptionID: .onboardingFeatureItemCustomMachineDescription
      )
      FeatureItem(
        featureIcon: .restoreImageManagement,
        titleID: .onboardingFeatureItemRestoreImageManagementTitle,
        descriptionID: .onboardingFeatureItemRestoreImageManagementDescription
      )
      FeatureItem(
        featureIcon: .versions,
        titleID: .onboardingFeatureItemVersionsTitle,
        descriptionID: .onboardingFeatureItemVersionsDescription
      )
      FeatureItem(
        featureIcon: .library,
        titleID: .onboardingFeatureItemLibraryTitle,
        descriptionID: .onboardingFeatureItemLibraryDescription
      )
    }
  }
}
