//
// SingleWindowView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftUI

  public struct SingleWindowViewValue<ViewType: SingleWindowView>: DefaultableViewValue {
    public static var `default`: Self {
      .init()
    }

    private init() {}
  }

  public protocol SingleWindowView: View {
    associatedtype Value: DefaultableViewValue = SingleWindowViewValue<Self>
    init()
  }

  extension SingleWindowView {
    public init(_: Binding<Value>) {
      self.init()
    }
  }

  extension WindowGroup {
    public init<V: SingleWindowView>(
      singleOf _: V.Type
    ) where Content == PresentedWindowContent<V.Value, V> {
      self.init { value in
        V(value)
      } defaultValue: {
        V.Value.default
      }
    }
  }
#endif
