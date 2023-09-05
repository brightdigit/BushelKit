//
// HubViewKey.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import Foundation
  import SwiftUI

  private struct HubViewKey: EnvironmentKey {
    typealias Value = ViewValue

    static var defaultValue: ViewValue = .init { _ in
      EmptyView()
    }
  }

  public struct ViewValue {
    public init(content: @escaping (Binding<InstallImage?>) -> some View) {
      self.content = { image in
        AnyView(content(image))
      }
    }

    let content: (Binding<InstallImage?>) -> AnyView
    func callAsFunction(_ selectedHubImage: Binding<InstallImage?>) -> some View {
      content(selectedHubImage)
    }
  }

  public extension EnvironmentValues {
    var hubView: ViewValue {
      get { self[HubViewKey.self] }
      set { self[HubViewKey.self] = newValue }
    }
  }

  public extension Scene {
    func hubView(
      _ view: @escaping (Binding<InstallImage?>) -> some View
    ) -> some Scene {
      self.environment(\.hubView, .init(content: view))
    }
  }

  public extension View {
    func sheet(isPresented: Binding<Bool>, selectedHubImage: Binding<InstallImage?>, onDismiss: (() -> Void)? = nil, _ viewValue: ViewValue) -> some View {
      self.sheet(isPresented: isPresented, onDismiss: onDismiss) {
        viewValue(selectedHubImage)
      }
    }
  }
#endif
