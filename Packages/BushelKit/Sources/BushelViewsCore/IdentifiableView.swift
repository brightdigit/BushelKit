//
// IdentifiableView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct IdentifiableViewModifier: ViewModifier {
    let id: UUID

    func body(content: Content) -> some View {
      IdentifiableView(content, id: id)
    }
  }

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
    func id(_ id: UUID) -> some View {
      self.modifier(IdentifiableViewModifier(id: id))
    }
  }
#endif
