//
// IdentifiableView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  struct IdentifiableViewModifier: ViewModifier {
    let id: Int

    func body(content: Content) -> some View {
      IdentifiableView(content, id: id)
    }
  }

  @MainActor
  public struct IdentifiableView: Identifiable, View, Sendable {
    let content: any View
    public let id: Int

    public var body: some View {
      AnyView(content)
    }

    public init(_ content: any View, id: Int) {
      self.content = content
      self.id = id
    }

    public init(_ content: @escaping () -> some View, id: Int) {
      self.content = content()
      self.id = id
    }
  }

//    extension View {
//        func id(_ id: UUID) -> some View {
//            modifier(IdentifiableViewModifier(id: id))
//        }
//    }
#endif
