//
// MarketplaceSettings.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public struct MarketplaceSettings {
  private init(groupIDs: [String], primaryGroupID: String) {
    self.groupIDs = groupIDs
    self.primaryGroupID = primaryGroupID
  }

  public static let `default`: MarketplaceSettings = .init()!
  public let groupIDs: [String]
  public let primaryGroupID: String
}

private extension MarketplaceSettings {
  init?(bundle: Bundle = .main) {
    guard let groupIDs = (bundle.object(forInfoDictionaryKey: "BrightDigitStoreGroupIDList") as? [Any])?.map(String.init(describing:)) else {
      return nil
    }
    guard let primaryGroupID = groupIDs.first else {
      return nil
    }
    self.init(groupIDs: groupIDs, primaryGroupID: primaryGroupID)
  }
}
