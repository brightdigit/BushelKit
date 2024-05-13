//
// HubViewKey.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftUI

  public struct ViewValue {
    let content: (Binding<(any InstallImage)?>) -> AnyView

    public init(content: @escaping (Binding<(any InstallImage)?>) -> some View) {
      self.content = { image in
        AnyView(content(image))
      }
    }

    func callAsFunction(_ selectedHubImage: Binding<(any InstallImage)?>) -> some View {
      content(selectedHubImage)
    }
  }

  private struct HubViewKey: EnvironmentKey {
    typealias Value = ViewValue

    static let defaultValue: ViewValue = .init { _ in
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
    public func hubView(
      _ view: @escaping (Binding<(any InstallImage)?>) -> some View
    ) -> some Scene {
      self.environment(\.hubView, .init(content: view))
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  extension View {
    public func hubView(
      _ view: @escaping (Binding<(any InstallImage)?>) -> some View
    ) -> some View {
      self.environment(\.hubView, .init(content: view))
    }
  }

  extension View {
    public func sheet(
      isPresented: Binding<Bool>,
      selectedHubImage: Binding<(any InstallImage)?>,
      onDismiss: (() -> Void)? = nil,
      _ viewValue: ViewValue
    ) -> some View {
      self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
        viewValue(selectedHubImage)
      }
    }
  }
#endif
