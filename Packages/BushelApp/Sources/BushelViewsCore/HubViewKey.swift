//
// HubViewKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftUI

  public struct ViewValue: Sendable {
    let content: @Sendable @MainActor (Binding<(any InstallImage)?>) -> AnyView

    public init(content: @Sendable @escaping @MainActor (Binding<(any InstallImage)?>) -> some View) {
      self.content = { image in
        AnyView(content(image))
      }
    }

    @MainActor func callAsFunction(_ selectedHubImage: Binding<(any InstallImage)?>) -> some View {
      content(selectedHubImage)
    }
  }

  private struct HubViewKey: EnvironmentKey {
    typealias Value = ViewValue

    static let defaultValue = ViewValue { _ in
      EmptyView()
    }
  }

  extension EnvironmentValues {
    public var hubView: ViewValue {
      get { self[HubViewKey.self] }
      set { self[HubViewKey.self] = newValue }
    }
  }

  extension Scene {
    @MainActor
    public func hubView(
      _ view: @Sendable @escaping @MainActor (Binding<(any InstallImage)?>) -> some View
    ) -> some Scene {
      self.environment(\.hubView, .init(content: view))
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  extension View {
    @MainActor
    public func hubView(
      _ view: @Sendable @escaping @MainActor (Binding<(any InstallImage)?>) -> some View
    ) -> some View {
      self.environment(\.hubView, .init(content: view))
    }
  }

  extension View {
    @MainActor
    public func sheet(
      isPresented: Binding<Bool>,
      selectedHubImage: Binding<(any InstallImage)?>,
      onDismiss: (@MainActor () -> Void)? = nil,
      _ viewValue: ViewValue
    ) -> some View {
      self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
        viewValue(selectedHubImage)
      }
    }
  }
#endif
