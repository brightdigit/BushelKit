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

  extension Sessionable {
    public func anyView(_ settings: Binding<ScreenSettingsType>) -> AnyView {
      .init(self.view(settings))
    }
  }
#endif
