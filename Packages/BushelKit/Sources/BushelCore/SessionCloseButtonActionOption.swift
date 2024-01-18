//
// SessionCloseButtonActionOption.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum SessionCloseButtonActionOption: Int, CaseIterable, Localizable {
  case forceTurnOff = 10
  case saveSnapshotAndForceTurnOff = 20

  public static let emptyValue = 0

  public static let defaultLocalizedStringID = "settingsSessionCloseAskUser"
  public static let localizedStringIDMapping: [Self: String] = [
    .forceTurnOff: "settingsSessionCloseForceTurnOff",
    .saveSnapshotAndForceTurnOff: "settingsSessionCloseSaveSnapshotTurnOff"
  ]
}

public extension SessionCloseButtonActionOption {
  static var pickerValues: [SessionCloseButtonActionOption?] {
    Self.allCases + [nil]
  }
}

public extension Optional where Wrapped == SessionCloseButtonActionOption {
  var tag: Int {
    self?.rawValue ?? Wrapped.emptyValue
  }

  var requiresSubscription: Bool {
    self == .saveSnapshotAndForceTurnOff
  }
}
