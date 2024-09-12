//
// AdvancedSettingsView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelLocalization
  import BushelLogging
  import BushelViewsCore
  import RadiantKit
  import SwiftData
  import SwiftUI

  #warning("Show number of machines and images")
  #warning("Show current size")
  @MainActor
  internal struct AdvancedSettingsView: View, Loggable, Sendable {
    internal enum AdvancedSettingsError: LocalizedError {
      case databaseError(SwiftDataError)
      case missingBundleIdentifer
      case unknownError(any Error)

      var errorDescription: String? {
        switch self {
        case let .databaseError(error):
          "Unable to clear the database: \(error)"
        case .missingBundleIdentifer:
          "Missing bundle indentifier to clear all settings"
        case let .unknownError(error):
          error.localizedDescription
        }
      }
    }

    @State var isAdvancedButtonsVisible = false
    @State var error: AdvancedSettingsError?
    @State var confimResetUserSettings = false
    @State var confimClearDatbase = false
    @State var confirmClearAllSettings = false
    @State var presentDebugDatabaseView = false

    @AppStorage(for: Tracking.Error.self)
    var errorTrackingEnabled

    @AppStorage(for: Tracking.Analytics.self)
    var analyticsTrackingEnabled

    @Environment(\.database) private var database

    var body: some View {
      Form {
        resetSection()
        trackingSection()
        if self.isAdvancedButtonsVisible {
          debugSection()
        }
      }
      .formStyle(.grouped)
      .confirmationDialog(
        Text(.settingsResetUserSettingsConfirmationTitle),
        isPresented: self.$confimResetUserSettings,
        actions: {
          Button(
            role: .destructive,
            .settingsResetUserSettingsConfirmationButton,
            action: self.clearResetUserSettingAction
          )
        }
      )
      .confirmationDialog(
        Text(.settingsClearDatabaseConfirmationTitle),
        isPresented: self.$confimClearDatbase,
        actions: {
          Button(
            role: .destructive,
            .settingsClearDatabaseConfirmationButton,
            action: self.clearDatabaseAction
          )
        }
      )
      .confirmationDialog(
        Text(.settingsResetAllConfirmationTitle),
        isPresented: self.$confirmClearAllSettings,
        actions: {
          Button(role: .destructive, .settingsResetAllConfirmationButton) {
            self.clearResetUserSettingAction()
            self.clearDatabaseAction()
          }
        }
      )
      .sheet(isPresented: self.$presentDebugDatabaseView, content: {
        DebugDatabaseView()
      })
    }

    private func resetSection() -> some View {
      Section {
        GuidedLabeledContent(
          LocalizedStringID.settingsResetUserSettingsDescription,
          destructiveButtonTextID: LocalizedStringID.settingsResetUserSettingsLabel,
          destructiveButtonSystemName: "exclamationmark.triangle",
          labelTextID: LocalizedStringID.settingsResetUserSettingsLabel,
          labelImageSystemName: "list.bullet.rectangle.fill"
        ) {
          self.confimResetUserSettings = true
        }
        GuidedLabeledContent(
          LocalizedStringID.settingsClearDatabaseDescription,
          destructiveButtonTextID: LocalizedStringID.settingsClearDatabaseLabel,
          destructiveButtonSystemName: "exclamationmark.triangle.fill",
          labelTextID: LocalizedStringID.settingsClearDatabaseLabel,
          labelImageSystemName: "tablecells"
        ) {
          self.confimClearDatbase = true
        }
        GuidedLabeledContent(
          LocalizedStringID.settingsResetAllDescription,
          destructiveButtonTextID: LocalizedStringID.settingsClearDatabaseLabel,
          destructiveButtonSystemName: "exclamationmark.triangle.fill",
          labelTextID: LocalizedStringID.settingsResetAllLabel,
          labelImageSystemName: "checkmark.gobackward"
        ) {
          self.confirmClearAllSettings = true
        }
        .foregroundStyle(Color.red)
      } footer: {
        Button("More Actions") {
          self.isAdvancedButtonsVisible.toggle()
        }.keyboardShortcut(KeyEquivalent("d"), modifiers: [.command, .option, .control])
          .opacity(0.0)
      }
    }

    private func trackingSection() -> some View {
      Section {
        LabeledContent {
          Toggle(
            isOn: self.$errorTrackingEnabled
          ) {
            Text(LocalizedStringID.enabled)
          }
        } label: {
          Text(LocalizedStringID.settingsErrorTrackingEnabledText)
        }
        LabeledContent {
          Toggle(
            isOn: self.$analyticsTrackingEnabled
          ) {
            Text(LocalizedStringID.enabled)
          }
        } label: {
          Text(LocalizedStringID.settingsAnalyticsTrackingEnabledText)
        }
      }
    }

    private func debugSection() -> some View {
      Section {
        GuidedLabeledContent(
          LocalizedStringID.settingsClearDatabaseDescription
        ) {
          Button(
            role: .destructive
          ) {
            self.presentDebugDatabaseView = true
          } label: {
            HStack {
              Text(.settingsDatabaseShowButton)
            }
          }
        } label: {
          HStack {
            Image(systemName: "tablecells")
            Text(.settingsDatabaseShowTitle)
          }
        }
      }
    }

    func clearResetUserSettingAction() {
      do {
        try Bundle.main.clearUserDefaults()
      } catch is Bundle.MissingIdentifierError {
        Self.logger.error("Couldn't find domain name or bundleIdentifier to clear.")
        assertionFailure("Couldn't find domain name or bundleIdentifier to clear.")
        self.error = .missingBundleIdentifer
      } catch {
        Self.logger.critical("Unknown error: \(error)")
        assertionFailure("Unknown error: \(error)")
        self.error = .unknownError(error)
      }
    }

    func clearDatabaseAction() {
      Task {
        do {
          try await self.database.deleteAll(of: .all)
        } catch let error as SwiftDataError {
          Self.logger.error("Error trying to clear the database.")
          assertionFailure("Error trying to clear the database.")
          self.error = .databaseError(error)
        } catch {
          Self.logger.critical("Unknown error: \(error)")
          assertionFailure("Unknown error: \(error)")
          self.error = .unknownError(error)
        }
      }
    }
  }

  #Preview {
    TabView {
      AdvancedSettingsView().tabItem {
        Label("Advanced", systemImage: "star")
      }
    }.padding(20)
      .frame(width: 375, height: 150)
  }
#endif
