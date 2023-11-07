//
// FeatureItem.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelLocalization

struct FeatureItem: Identifiable {
  let icon: Icon
  let titleID: LocalizedStringID
  let descriptionID: LocalizedStringID
  let id: String

  internal init(
    featureIcon: Icons.Feature,
    titleID: LocalizedStringID,
    descriptionID: LocalizedStringID,
    id: String? = nil
  ) {
    self.init(icon: featureIcon, titleID: titleID, descriptionID: descriptionID, id: id)
  }

  internal init(
    icon: Icon,
    titleID: LocalizedStringID,
    descriptionID: LocalizedStringID,
    id: String? = nil
  ) {
    self.icon = icon
    self.titleID = titleID
    self.descriptionID = descriptionID
    self.id = id ?? [icon.name, titleID.rawValue, descriptionID.rawValue].joined()
  }
}
