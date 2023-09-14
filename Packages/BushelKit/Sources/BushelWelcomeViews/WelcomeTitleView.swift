//
// WelcomeTitleView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers) && os(macOS)
  import BushelCore
  import BushelData
  import BushelLogging
  import BushelMarketEnvironment
  import BushelUT
  import BushelViewsCore
  import SwiftUI
  import UniformTypeIdentifiers

  struct WelcomeTitleView: View, LoggerCategorized {
    @State var openDocumentIsVisible = false
    @Environment(\.marketplace) var marketplace
    @Environment(\.openWindow) var openWindow
    @Environment(\.openFileURL) var openFileURL
    @Environment(\.newLibrary) var newLibrary
    @Environment(\.openMachine) var openMachine
    @Environment(\.modelContext) var modelContext

    var body: some View {
      HStack {
        Spacer()
        VStack {
          Spacer()
          Image.resource("Logo").resizable().aspectRatio(contentMode: .fit).frame(height: 120)
          HStack {
            Text(.welcomeToBushel)
              .font(.system(size: 36.0))
              .fontWeight(.bold)

            if (marketplace.subscriptionEndDate ?? .distantPast) > .now {
              Text("Pro")
                .font(.system(size: 36.0))
                .fontWeight(.bold)
                .foregroundStyle(.tint)
                .italic()
            }
          }
          Text(
            .key(.version),
            .text(
              // swiftlint:disable:next line_length
              "\(Configuration.versionFormatted.marketingVersion) (\(Configuration.versionFormatted.buildNumberHex))"
            )
          )
          .font(.system(size: 12.0))
          .fontWeight(.medium)
          .foregroundColor(.secondary)

          Spacer(minLength: 10.0)
          VStack(alignment: .leading) {
            WelcomeActionButton(
              imageSystemName: "plus.app",
              titleID: .welcomeNewMachineTitle,
              descriptionID: .welcomeNewMachineDescription
            ) {
              // newMachine()
              openWindow(value: MachineBuildRequest())
            }

            WelcomeActionButton(
              imageSystemName: "square.and.arrow.down",
              titleID: .welcomeExistingMachineTitle,
              descriptionID: .welcomeExistingMachineDescription
            ) {
              openMachine(with: openWindow)
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
              titleID: .welcomeStartLibraryTitle,
              descriptionID: .welcomeStartLibraryDescription
            ) {
              newLibrary(with: openWindow)
            }
          }.padding(20.0)
          Spacer()
        }.padding()
        Spacer()
      }
    }
  }

  struct WelcomeTitleView_Previews: PreviewProvider {
    static var previews: some View {
      WelcomeTitleView()
    }
  }
#endif
