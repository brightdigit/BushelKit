//
// GeneralSettingsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelLocalization
  import BushelViewsCore
  import SwiftUI

  struct GeneralSettingsView: View {
    @AppStorage(for: Preference.MachineShutdownAction.self)
    var machineShutdownActionOption: MachineShutdownActionOption?
    @AppStorage(for: Preference.SessionCloseButtonAction.self)
    var sessionCloseButtonActionOption: SessionCloseButtonActionOption?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.marketplace) var marketplace
    var body: some View {
      Form {
        Section {
          LabeledContent {
            Toggle(
              isOn: self.$machineShutdownActionOption.map(
                to: { $0 == .closeWindow },
                from: { $0 ? .closeWindow : nil }
              )
            ) {
              Text(LocalizedStringID.settingsMachineShutdownAlwaysClose)
            }
          } label: {
            Text(LocalizedStringID.settingsMachineShutdown)
          }

          LabeledContent {
            Picker(
              selection:
              self.$sessionCloseButtonActionOption.map(
                to: { $0.tag },
                from: SessionCloseButtonActionOption.init
              )
            ) {
              ForEach(
                SessionCloseButtonActionOption.pickerValues,
                id: \.tag
              ) { value in
                if !value.requiresSubscription || marketplace.purchased {
                  Text(value.localizedID).tag(value.tag)
                }
              }
            } label: {
              Text(LocalizedStringID.settingsSessionCloseLabel)
            }.labelsHidden()
          } label: {
            Text(LocalizedStringID.settingsSessionCloseLabel)
          }
        } header: {
          Text(LocalizedStringID.settingsActiveSession)
        }
        Section {
          GuidedLabeledContent(
            LocalizedStringID.settingsAutomaticSnapshotsDescription
          ) {
            AutoSnapshotIntervalSettingView()
          } label: {
            Text(.settingsAutomaticSnapshotsLabel)
          }
        } header: {
          Text(LocalizedStringID.settingsAutomaticSnapshotsSection)
        }

        Section {
          HStack {
            Spacer()
            LabeledContent {
              Button(.settingsClearRecentDocuments) {}
            } label: {
              Text(LocalizedStringID.settingsClearAllRecentDocuments)
            }
          }
        } header: {
          Text(LocalizedStringID.recentDocuments)
        }
      }.formStyle(.grouped)
    }
  }

  public extension Optional where Wrapped == SessionCloseButtonActionOption {
    var localizedID: LocalizedID {
      let value = LocalizedStringID(rawValue: self.localizedStringIDRawValue)
      assert(value != nil)
      return value ?? LocalizedStringID.settingsSessionCloseLabel
    }
  }

#endif
