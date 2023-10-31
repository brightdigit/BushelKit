//
// Sessionable.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftUI

  public protocol Sessionable<ScreenSettingsType> {
    associatedtype ScreenSettingsType
    associatedtype Content: View
    func view(_ settings: Binding<ScreenSettingsType>) -> Content
  }

  public extension Sessionable {
    func anyView(_ settings: Binding<ScreenSettingsType>) -> AnyView {
      .init(self.view(settings))
    }
  }
#endif
