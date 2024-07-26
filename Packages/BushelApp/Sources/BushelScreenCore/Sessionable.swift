//
// Sessionable.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import Foundation

  public import SwiftUI

  public protocol Sessionable<ScreenSettingsType> {
    associatedtype ScreenSettingsType
    associatedtype Content: View
    @MainActor func view(_ settings: Binding<ScreenSettingsType>) -> Content
  }

  extension Sessionable {
    @MainActor
    public func anyView(_ settings: Binding<ScreenSettingsType>) -> AnyView {
      .init(self.view(settings))
    }
  }
#endif
