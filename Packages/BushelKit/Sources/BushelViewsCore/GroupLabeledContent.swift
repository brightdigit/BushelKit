//
// GroupLabeledContent.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import SwiftUI

  public struct GroupLabeledContent<Label: View>: View {
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

    public init(
      @LabeledContentBuilder _ content: @escaping () -> [IdentifiableView],
      @ViewBuilder label: @escaping () -> Label
    ) {
      self.groups = content
      self.label = label
    }
  }

  public extension GroupLabeledContent {
    init(
      @ViewBuilder _ content: @escaping () -> some View,
      @ViewBuilder group: @escaping () -> some View,
      @ViewBuilder label: @escaping () -> Label
    ) {
      self.init({
        LabeledContent(content: content, label: group)
      }, label: label)
    }
  }

#endif
