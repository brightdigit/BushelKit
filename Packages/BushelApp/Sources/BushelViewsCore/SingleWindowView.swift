//
// SingleWindowView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore

  public import Foundation

  public import SwiftUI

  public struct SingleWindowViewValue<ViewType: SingleWindowView>: DefaultableViewValue {
    public static var `default`: Self {
      .init()
    }

    private init() {}
  }

  @MainActor
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
    @MainActor
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
