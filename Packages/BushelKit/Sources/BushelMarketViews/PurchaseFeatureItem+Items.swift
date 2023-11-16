//
// PurchaseFeatureItem+Items.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelLocalization
import Foundation

extension PurchaseFeatureItem {
  static let automaticSnapshots: PurchaseFeatureItem =
    .init(
      systemName: "camera.badge.clock.fill",
      titleID: .purchaseFeatureAutomaticSnapshotsTitle,
      descriptionID: .purchaseFeatureAutomaticSnapshotsDescription
    )

  static let snapshotNotes: PurchaseFeatureItem =
    .init(
      systemName: "square.and.pencil",
      titleID: .purchaseFeatureSnapshotNotesTitle,
      descriptionID: .purchaseFeatureSnapshotNotesDescription
    )
  static let shutdownSnapshot: PurchaseFeatureItem =
    .init(
      systemName: "power.circle.fill",
      titleID: .purchaseFeatureShutdownSnapshotTitle,
      descriptionID: .purchaseFeatureShutdownSnapshotDescription
    )
}
