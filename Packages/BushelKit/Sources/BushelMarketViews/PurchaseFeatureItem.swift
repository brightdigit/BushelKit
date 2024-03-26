//
// PurchaseFeatureItem.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelLocalization

struct PurchaseFeatureItem: Identifiable {
  let systemName: String
  let titleID: LocalizedStringID
  let descriptionID: LocalizedStringID
  let id: String
  internal init(
    systemName: String,
    titleID: LocalizedStringID,
    descriptionID: LocalizedStringID,
    id: String? = nil
  ) {
    self.systemName = systemName
    self.titleID = titleID
    self.descriptionID = descriptionID
    self.id = id ?? [titleID.rawValue, descriptionID.rawValue, systemName].joined()
  }
}
