//
// WelcomeActionListView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelViewsCore
  import SwiftUI
  import UniformTypeIdentifiers

  internal struct WelcomeActionListView: View, Loggable {
    @Environment(\.openWindow) var openWindow
    @Environment(\.openFileURL) var openFileURL
    #if os(macOS)
      @Environment(\.newLibrary) var newLibrary
      @Environment(\.openMachine) var openMachine
    #endif
    @Environment(\.database) var database
    @State var openDocumentIsVisible = false

    var body: some View {
      VStack(alignment: .leading) {
        WelcomeActionButton(
          imageSystemName: "plus.app",
          titleID: .welcomeNewMachineTitle
        ) {
          // newMachine()
          openWindow(value: MachineBuildRequest())
        }

        WelcomeActionButton(
          imageSystemName: "square.and.arrow.down",
          titleID: .welcomeExistingMachineTitle
        ) {
          #if os(macOS)
            openMachine(with: openWindow)
          #endif
        }
        .fileImporter(
          isPresented: self.$openDocumentIsVisible,
          allowedContentTypes: UTType.allowedContentTypes(for: .virtualMachine)
        ) { result in
          Task {
            let url: URL
            do {
              let currentURL = try result.get()
              url = try await BookmarkData.withDatabase(database, fromURL: currentURL) {
                try $0.fetchURL()
              }
            } catch {
              Self.logger.error("Unable to open machine: \(error)")
              assertionFailure(error: error)
              return
            }
            openFileURL(url, with: openWindow)
          }
        }

        WelcomeActionButton(
          imageSystemName: "server.rack",
          titleID: .welcomeStartLibraryTitle
        ) {
          #if os(macOS)
            newLibrary(with: openWindow)
          #endif
        }

        // TipView(tip)
      }
      .accessibilityElement(children: .contain)
      .accessibilityLabel("Welcome Action Buttons")
    }
  }

  #Preview {
    WelcomeActionListView()
  }
#endif
