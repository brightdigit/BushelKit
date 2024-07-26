//
// MarketplaceSettings.swift
// Copyright (c) 2024 BrightDigit.
//

public import Foundation

public struct MarketplaceSettings: Sendable {
  // swiftlint:disable:next force_unwrapping
  public static let `default`: MarketplaceSettings = .init()!
  public let groupIDs: [String]
  public let primaryGroupID: String

  private init(groupIDs: [String], primaryGroupID: String) {
    self.groupIDs = groupIDs
    self.primaryGroupID = primaryGroupID
  }
}

extension Bundle {
  fileprivate var groupIDs: [String]? {
    guard let dictionaryValue = self.object(forInfoDictionaryKey: "BrightDigitStoreGroupIDList") else {
      return nil
    }

    guard let values = dictionaryValue as? [Any] else {
      return nil
    }

    return values.map(String.init(describing:))
  }
}

extension MarketplaceSettings {
  fileprivate init?(bundle: Bundle = .main) {
    guard let groupIDs = bundle.groupIDs else {
      return nil
    }
    guard let primaryGroupID = groupIDs.first else {
      return nil
    }
    self.init(groupIDs: groupIDs, primaryGroupID: primaryGroupID)
  }
}
