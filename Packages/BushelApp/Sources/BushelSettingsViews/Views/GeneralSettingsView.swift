//
// GeneralSettingsView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI) && os(macOS)
  import BushelCore
  import BushelLocalization
  import RadiantKit
  import SwiftUI

  internal struct GeneralSettingsView: View {
    @State
    private var recentDocumentsTypeFilterSelection =
      DocumentTypeFilterOption.machinesAndLibraries.rawValue

    @AppStorage(for: RecentDocuments.TypeFilter.self)
    private var recentDocumentsTypeFilter

    @AppStorage(for: RecentDocuments.ClearDate.self)
    private var recentDocumentsClearDate: Date?

    @AppStorage(for: Preference.MachineShutdownAction.self)
    var machineShutdownActionOption: MachineShutdownActionOption?

    @AppStorage(for: Preference.SessionCloseButtonAction.self)
    var sessionCloseButtonActionOption: SessionCloseButtonActionOption?

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.marketplace) var marketplace

    var body: some View {
      Form {
        machineCloseButtonSection()
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

        recentDocumentsSection()
      }
      .formStyle(.grouped)
      .onChange(of: self.recentDocumentsTypeFilterSelection) { _, newValue in
        guard let newTypeFilter = DocumentTypeFilterOption(rawValue: newValue)?.typeFilter else {
          assertionFailure("Invalid Type")
          return
        }
        guard newTypeFilter != self.recentDocumentsTypeFilter else {
          return
        }
        self.recentDocumentsTypeFilter = newTypeFilter
      }
      .onChange(of: self.recentDocumentsTypeFilter, initial: true) { _, newValue in
        let newSelection = DocumentTypeFilterOption(filter: newValue)
        guard newSelection.rawValue != self.recentDocumentsTypeFilterSelection else {
          return
        }
        self.recentDocumentsTypeFilterSelection = newSelection.rawValue
      }
    }

    private func recentDocumentsSection() -> some View {
      Section {
        HStack {
          Spacer()
          LabeledContent {
            Picker(
              selection: self.$recentDocumentsTypeFilterSelection,
              content: {
                ForEach(DocumentTypeFilterOption.allCases) { value in
                  Text(
                    value.localizedID(default: LocalizedStringID.settingsFilterRecentDocumentsNone)
                  )
                  .tag(value.tag)
                }
              },
              label: {
                Text(.settingsFilterRecentDocumentsNone)
              }
            ).labelsHidden()
          } label: {
            Text(.settingsFilterRecentDocuments)
          }
        }
        HStack {
          Spacer()
          LabeledContent {
            Button(.settingsClearRecentDocuments) {
              self.recentDocumentsClearDate = .init()
            }
          } label: {
            Text(LocalizedStringID.settingsClearAllRecentDocuments)
          }
        }
      } header: {
        Text(LocalizedStringID.recentDocuments)
      }
    }

    private func machineCloseButtonSection() -> some View {
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
                Text(
                  value.localizedID(default: LocalizedStringID.settingsSessionCloseLabel)
                )
                .tag(value.tag)
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
    }
  }

#endif
