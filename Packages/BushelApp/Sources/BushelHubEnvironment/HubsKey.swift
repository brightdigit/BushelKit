//
// HubsKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore

  public import BushelHub
  import Foundation

  public import SwiftUI

  private struct HubsKey: EnvironmentKey {
    typealias Value = [Hub]

    static let defaultValue: [Hub] = []
  }

  extension EnvironmentValues {
    public var hubs: [Hub] {
      get { self[HubsKey.self] }
      set { self[HubsKey.self] = newValue }
    }
  }
#endif
