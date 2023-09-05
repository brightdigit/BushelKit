//
// GroupLabeledContent.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public struct IdentifiableView: Identifiable {
    internal init(_ content: any View, id: UUID = .init()) {
      self.content = content
      self.id = id
    }

    let content: any View
    public let id: UUID
  }

  @resultBuilder
  public enum LabeledContentBuilder {
    public static func buildPartialBlock(first: LabeledContent<some View, some View>) -> [IdentifiableView] {
      [
        IdentifiableView(
          first.labeledContentStyle(.vertical()))
      ]
    }

    public static func buildPartialBlock(accumulated: [IdentifiableView], next: LabeledContent<some View, some View>) -> [IdentifiableView] {
      accumulated + [IdentifiableView(next.labeledContentStyle(.vertical()))]
    }
  }

  public struct GroupLabeledContent<Label: View>: View {
    public init(@LabeledContentBuilder _ content: @escaping () -> [IdentifiableView], @ViewBuilder label: @escaping () -> Label) {
      self.groups = content
      self.label = label
    }

    let groups: () -> [IdentifiableView]
    let label: () -> Label
    public var body: some View {
      LabeledContent {
        VStack {
          ForEach(groups()) {
            AnyView($0.content)
          }
        }
      } label: {
        self.label()
      }
    }
  }

  public extension GroupLabeledContent {
    init(
      @ViewBuilder _ content: @escaping () -> some View,
      @ViewBuilder group: @escaping () -> some View,
      @ViewBuilder label: @escaping () -> Label
    ) {
      self.init({
        LabeledContent(content: content, label: label)
      }, label: label)
    }
  }

//  #Preview {
//    GroupLabeledContent {
//      LabeledContent("Test") {
//        Text("hello")
//      }
//      LabeledContent("Test") {
//        Text("hello")
//      }
//    } label: {
//      Text("hello")
//    }
//  }
#endif
