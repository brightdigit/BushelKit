//
// FujiFeaturesView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore

  public import BushelOnboardingCore

  public import RadiantKit

  public import SwiftUI

  public struct FujiFeaturesView: SingleWindowView {
    public typealias Value = OnboardingWindowValue

    @AppStorage(for: Onboarding.Fuji.self) private var onboardedAt
    @Environment(\.dismiss) var dismiss

    public var body: some View {
      FeatureListView(title: .whatsNew) {
        FeatureItem(
          featureIcon: .builder,
          titleID: .onboardingFeatureItemNewMachineCreationDialogTitle,
          descriptionID: .onboardingFeatureItemNewMachineCreationDialogDescription
        )

        FeatureItem(
          featureIcon: .installation,
          titleID: .onboardingFeatureItemImprovedInstallationScreenTitle,
          descriptionID: .onboardingFeatureItemImprovedInstallationScreenDescription
        )
        FeatureItem(
          featureIcon: .performance,
          titleID: .onboardingFeatureItemOverallPerformanceImprovementsTitle,
          descriptionID: .onboardingFeatureItemOverallPerformanceImprovementsDescription
        )
        FeatureItem(
          featureIcon: .snapshots,
          titleID: .onboardingFeatureItemSnapshotsTitle,
          descriptionID: .onboardingFeatureItemSnapshotsDescription
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
      } _: {
        self.onboardedAt = Date()
        self.dismiss()
      }
    }

    public init() {}
  }

  #Preview {
    FujiFeaturesView()
  }
#endif
