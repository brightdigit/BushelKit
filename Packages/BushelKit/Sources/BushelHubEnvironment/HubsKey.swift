//
// HubsKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelHub
  import Foundation
  import SwiftUI

  private struct HubsKey: EnvironmentKey {
    typealias Value = [Hub]

    static var defaultValue: [Hub] = []
  }

  public extension EnvironmentValues {
    var hubs: [Hub] {
      get { self[HubsKey.self] }
      set { self[HubsKey.self] = newValue }
    }
  }
#endif
