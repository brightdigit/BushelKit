//
// WelcomeActionListView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelViewsCore
  import SwiftUI
  import UniformTypeIdentifiers

  struct WelcomeActionListView: View, LoggerCategorized {
    @Environment(\.openWindow) var openWindow
    @Environment(\.openFileURL) var openFileURL
    #if os(macOS)
      @Environment(\.newLibrary) var newLibrary
      @Environment(\.openMachine) var openMachine
    #endif
    @Environment(\.modelContext) var modelContext
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
          let url: URL
          do {
            let currentURL = try result.get()
            let bookmark = try BookmarkData.resolveURL(currentURL, with: modelContext)
            url = try bookmark.fetchURL(using: modelContext, withURL: currentURL)
          } catch {
            Self.logger.error("Unable to open machine: \(error)")
            assertionFailure(error: error)
            return
          }
          openFileURL(url, with: openWindow)
        }

        WelcomeActionButton(
          imageSystemName: "server.rack",
          titleID: .welcomeStartLibraryTitle
        ) {
          #if os(macOS)
            newLibrary(with: openWindow)
          #endif
        }
      }
    }
  }

  #Preview {
    WelcomeActionListView()
  }
#endif
