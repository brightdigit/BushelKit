//
// DocumentTypeFilterOption.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public enum DocumentTypeFilterOption: Int, CaseIterable, Identifiable, Localizable, Sendable {
  case machinesOnly
  case machinesAndLibraries

  public static let localizedStringIDMapping: [Self: String] = [
    .machinesOnly: "settingsFilterRecentDocumentsMachinesOnly",
    .machinesAndLibraries: "settingsFilterRecentDocumentsNone"
  ]

  public var tag: Int {
    self.rawValue
  }

  public var id: Int {
    self.rawValue
  }

  public var typeFilter: DocumentTypeFilter {
    switch self {
    case .machinesAndLibraries:
      return []

    case .machinesOnly:
      return .libraries
    }
  }

  public init(filter: DocumentTypeFilter) {
    self = filter.contains(.libraries) ? .machinesOnly : .machinesAndLibraries
  }
}
