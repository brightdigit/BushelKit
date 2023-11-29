//
// RecentDocuments.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public enum RecentDocuments {
  public enum TypeFilter: AppStored, DefaultWrapped {
    public typealias Value = DocumentTypeFilter
    public static let keyType: KeyType = .reflecting
    public static let `default`: DocumentTypeFilter = .init()
  }

  public enum ClearDate: AppStored {
    public typealias Value = Date?
    public static let keyType: KeyType = .reflecting
  }
}
