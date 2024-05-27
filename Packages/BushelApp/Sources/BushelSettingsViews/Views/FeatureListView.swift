//
// FeatureListView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelFeatureFlags
  import BushelLocalization
  import BushelViewsCore
  import FeatherQuill
  import SwiftUI

  internal struct FeatureListView: View {
    @Environment(\.newDesignFeature) var newDesign
    @Environment(\.userFeedback) var userFeedback

    var body: some View {
      Form {
        Self.section(
          for: newDesign,
          label: LocalizedStringID.settingsFeaturesNewMachineDialogLabel,
          description: LocalizedStringID.settingsFeaturesNewMachineDialogDescription
        ) { bindingValue in
          Toggle(.enabled, isOn: bindingValue)
        }

        Section {
          GuidedLabeledContent(
            LocalizedStringID.settingsFeaturesUserFeedbackDescription
          ) {
            Toggle(.enabled, isOn: self.userFeedback.bindingValue)
          } label: {
            Text(LocalizedStringID.settingsFeaturesUserFeedbackLabel)
          }
          .disabled(!userFeedback.isAvailable)
          .opacity(userFeedback.isAvailable ? 1.0 : 0.5)
        }
      }.formStyle(.grouped)
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
