//
// Sessionable.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
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
