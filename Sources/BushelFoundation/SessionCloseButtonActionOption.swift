//
//  SessionCloseButtonActionOption.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import BushelUtilities
internal import Foundation

/// Represents the different options for the session close button action.
public enum SessionCloseButtonActionOption: Int, CaseIterable, Localizable, Sendable {
  /// Forcefully turns off the session.
  case forceTurnOff = 10
  /// Saves a snapshot and forcefully turns off the session.
  case saveSnapshotAndForceTurnOff = 20

  /// The empty value for this enum.
  public static let emptyValue = 0

  /// The default localized string ID for this enum.
  public static let defaultLocalizedStringID = "settingsSessionCloseAskUser"

  /// A mapping of each case to its corresponding localized string ID.
  public static let localizedStringIDMapping: [Self: String] = [
    .forceTurnOff: "settingsSessionCloseForceTurnOff",
    .saveSnapshotAndForceTurnOff: "settingsSessionCloseSaveSnapshotTurnOff",
  ]
}

extension SessionCloseButtonActionOption {
  /// A list of all the cases in this enum, plus a `nil` value.
  public static var pickerValues: [SessionCloseButtonActionOption?] {
    allCases + [nil]
  }
}

extension SessionCloseButtonActionOption? {
  /// The tag value for this option, which is the raw value of the enum case.
  /// If the value is `nil`, the `emptyValue` is returned.
  public var tag: Int {
    self?.rawValue ?? Wrapped.emptyValue
  }

  /// A boolean indicating whether this option requires a subscription.
  public var requiresSubscription: Bool {
    self == .saveSnapshotAndForceTurnOff
  }
}
