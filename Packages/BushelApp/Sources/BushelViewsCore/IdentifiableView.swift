//
// IdentifiableView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  @available(*, unavailable, message: "Use RadiantKit.")
  internal struct IdentifiableViewModifier: ViewModifier {
    let id: UUID

    func body(content: Content) -> some View {
      IdentifiableView(content, id: id)
    }
  }

  @available(*, unavailable, message: "Use RadiantKit.")
  public struct IdentifiableView: Identifiable, View {
    let content: any View
    public let id: UUID

    public var body: some View {
      AnyView(content)
    }

    public init(_ content: any View, id: UUID = .init()) {
      self.content = content
      self.id = id
    }

    public init(_ content: @escaping () -> some View, id: UUID = .init()) {
      self.content = content()
      self.id = id
    }
  }

  extension View {
    @available(*, unavailable, message: "Use RadiantKit.")
    func id(_ id: UUID) -> some View {
      self.modifier(IdentifiableViewModifier(id: id))
    }
  }
#endif
