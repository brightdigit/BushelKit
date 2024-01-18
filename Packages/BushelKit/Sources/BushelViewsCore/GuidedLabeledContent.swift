//
// GuidedLabeledContent.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import SwiftUI

  public struct GuidedLabeledContent<Label: View, Content: View, Description: View>: View {
    let content: () -> Content
    let label: () -> Label
    let description: () -> Description

    public var body: some View {
      VStack {
        LabeledContent(content: content, label: label)
        self.description()
      }
    }

    public init(
      _ content: @escaping () -> Content,
      label: @escaping () -> Label,
      description: @escaping () -> Description
    ) {
      self.content = content
      self.label = label
      self.description = description
    }
  }

  public extension GuidedLabeledContent where Description == GuidedLabeledContentDescriptionView {
    init(
      _ content: @escaping () -> Content,
      label: @escaping () -> Label,
      text: @escaping () -> Text,
      descriptionAlignment: GuidedLabeledContentDescriptionView.Alignment? = .leading
    ) {
      self.init(
        content,
        label: label
      ) {
        GuidedLabeledContentDescriptionView(alignment: descriptionAlignment, text: text)
      }
    }
  }
#endif
