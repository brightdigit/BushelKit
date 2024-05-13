//
// FeatureListView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelFeatureFlags
  import BushelLocalization
  import BushelViewsCore
  import SwiftUI

  struct FeatureListView: View {
    @Environment(\.newDesignFeature) var newDesign
    var body: some View {
      Form {
        Section {
          GuidedLabeledContent(
            LocalizedStringID.settingsFeaturesNewMachineDialogDescription
          ) {
            Toggle(.enabled, isOn: self.newDesign.bindingValue)
          } label: {
            Text(.settingsFeaturesNewMachineDialogLabel)
          }
          .disabled(!newDesign.isAvailable)
          .opacity(newDesign.isAvailable ? 1.0 : 0.5)
        }
      }.formStyle(.grouped)
    }
  }

  #Preview {
    FeatureListView()
  }
#endif
