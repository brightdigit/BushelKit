//
// SessionCloseButtonActionOption.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum SessionCloseButtonActionOption: Int, CaseIterable {
  case forceTurnOff = 10
  case saveSnapshotAndForceTurnOff = 20

  public static let emptyValue = 0

  // swiftlint:disable strict_fileprivate
  fileprivate static let defaultLocalizedStringID = "settingsSessionCloseAskUser"
  fileprivate static let localizedStringIDMapping: [Self: String] = [
    .forceTurnOff: "settingsSessionCloseForceTurnOff",
    .saveSnapshotAndForceTurnOff: "settingsSessionCloseSaveSnapshotTurnOff"
  ]
  // swiftlint:enable strict_fileprivate
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

  var localizedStringIDRawValue: String {
    guard let value = self else {
      return Wrapped.defaultLocalizedStringID
    }
    let string = Wrapped.localizedStringIDMapping[value]
    assert(string != nil)
    return string ?? ""
  }

  var requiresSubscription: Bool {
    self == .saveSnapshotAndForceTurnOff
  }
}
