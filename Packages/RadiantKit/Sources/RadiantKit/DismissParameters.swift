//
// DismissParameters.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct DismissParameters {
  #if canImport(SwiftUI)
    public typealias PageID = IdentifiableView.ID
  #else
    public typealias PageID = Int
  #endif
  public enum Action {
    case previous
    case next
    case cancel
  }

  public let currentPageIndex: Int
  public let currentPageID: PageID?
  public let action: Action
}
