//
// FeatureListView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelFeatureFlags
  import BushelLocalization
  import FeatherQuill
  import RadiantKit
  import SwiftUI

  internal struct FeatureListView: View {
    @Environment(\.userFeedback) var userFeedback

    var body: some View {
      Form {
        Self.section(
          userFeedback,
          label: .settingsFeaturesUserFeedbackLabel,
          description: .settingsFeaturesUserFeedbackDescription
        ) { bindingValue in
          Toggle(.enabled, isOn: bindingValue)
        }
      }.formStyle(.grouped)
    }

    static func section<ValueType>(
      _ feature: Feature<ValueType, some Any>,
      label: LocalizedStringID,
      description: LocalizedStringID,
      _ content: @escaping (Binding<ValueType>) -> some View
    ) -> some View {
      section(for: feature, label: label, description: description, content)
    }

    static func section<ValueType>(
      for feature: Feature<ValueType, some Any>,
      label: LocalizedID,
      description: LocalizedID,
      _ content: @escaping (Binding<ValueType>) -> some View
    ) -> some View {
      Section {
        GuidedLabeledContent(
          description
        ) {
          content(feature.bindingValue)
        } label: {
          Text(label)
        }
        .disabled(!feature.isAvailable)
        .opacity(feature.isAvailable ? 1.0 : 0.5)
      }
    }
  }

  #Preview {
    FeatureListView()
  }
#endif
