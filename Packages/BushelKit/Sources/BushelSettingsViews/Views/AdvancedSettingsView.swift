//
// AdvancedSettingsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelData
  import BushelLocalization
  import BushelLogging
  import BushelViewsCore
  import SwiftData
  import SwiftUI

  #warning("Show number of machines and images")
  #warning("Show current size")
  struct AdvancedSettingsView: View, LoggerCategorized {
    enum AdvancedSettingsError: LocalizedError {
      case databaseError(SwiftDataError)
      case missingBundleIdentifer
      case unknownError(Error)

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

    @State var error: AdvancedSettingsError?
    @State var confimResetUserSettings = false
    @State var confimClearDatbase = false
    @State var confirmClearAllSettings = false
    @State var presentDebugDatabaseView = false
    @Environment(\.modelContext) private var context

    var body: some View {
      Form {
        Section {
          GuidedLabeledContent(
            LocalizedStringID.settingsResetUserSettingsDescription
          ) {
            Button(
              role: .destructive
            ) {
              self.confimResetUserSettings = true
            } label: {
              HStack {
                Image(systemName: "exclamationmark.triangle")
                Text(.settingsResetUserSettingsLabel)
              }
            }
          } label: {
            HStack {
              Image(systemName: "list.bullet.rectangle.fill")
              Text(.settingsResetUserSettingsLabel)
            }
          }
          GuidedLabeledContent(
            LocalizedStringID.settingsClearDatabaseDescription
          ) {
            Button(
              role: .destructive
            ) {
              self.confimClearDatbase = true
            } label: {
              HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                Text(.settingsClearDatabaseLabel)
              }
            }
          } label: {
            HStack {
              Image(systemName: "tablecells")
              Text(.settingsClearDatabaseLabel)
            }
          }

          GuidedLabeledContent(
            LocalizedStringID.settingsResetAllDescription
          ) {
            Button(
              role: .destructive
            ) {
              self.confirmClearAllSettings = true
            } label: {
              HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                Text(.settingsResetAllLabel)
              }
            }
          } label: {
            HStack {
              Image(systemName: "checkmark.gobackward")
              Text(.settingsResetAllLabel)
            }
          }.foregroundStyle(Color.red)
        }
      }.formStyle(.grouped)
        .confirmationDialog(
          Text(.settingsResetUserSettingsConfirmationTitle),
          isPresented: self.$confimResetUserSettings,
          actions: {
            Button(role: .destructive, .settingsResetUserSettingsConfirmationButton) {
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
          }
        )
        .confirmationDialog(
          Text(.settingsClearDatabaseConfirmationTitle),
          isPresented: self.$confimClearDatbase,
          actions: {
            Button(role: .destructive, .settingsClearDatabaseConfirmationButton) {
              do {
                try self.context.clearDatabase()
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
        )
        .confirmationDialog(
          Text(.settingsResetAllConfirmationTitle),
          isPresented: self.$confirmClearAllSettings,
          actions: {
            Button(role: .destructive, .settingsResetAllConfirmationButton) {
              do {
                try Bundle.main.clearUserDefaults()
                try self.context.clearDatabase()
              } catch is Bundle.MissingIdentifierError {
                Self.logger.error("Couldn't find domain name or bundleIdentifier to clear.")
                assertionFailure("Couldn't find domain name or bundleIdentifier to clear.")
                self.error = .missingBundleIdentifer
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
        )
        .sheet(isPresented: self.$presentDebugDatabaseView, content: {
          DebugDatabaseView()
        })
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
