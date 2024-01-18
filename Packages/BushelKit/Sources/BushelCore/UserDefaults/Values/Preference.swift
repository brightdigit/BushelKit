//
// Preference.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum Preference {
  public enum MachineShutdownAction: AppStored {
    public typealias Value = MachineShutdownActionOption?
    public static let keyType: KeyType = .reflecting
  }

  public enum SessionCloseButtonAction: AppStored {
    public typealias Value = SessionCloseButtonActionOption?
    public static let keyType: KeyType = .reflecting
  }
}
