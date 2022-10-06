//
// WelcomeTitleView.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
  import SwiftUI
  import UniformTypeIdentifiers

  struct WelcomeTitleView: View {
    @State var openDocumentIsVisible = false

    var body: some View {
      HStack {
        Spacer()
        VStack {
          Spacer()
          Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(width: 150)
          Text(.welcomeToBushel).font(.custom("Raleway", size: 42.0)).fontWeight(.medium)
          Text(
            .key(.version),
            .text(
              // swiftlint:disable:next line_length
              "\(Configuration.applicationMarketingVersionText) (\(Configuration.applicationBuildFormatted))"
            )
          )
          .font(.custom("Raleway", size: 14.0))
          .fontWeight(.medium)
          .foregroundColor(.secondary)

          Spacer(minLength: 20.0)
          VStack(alignment: .leading) {
            WelcomeActionButton(
              imageSystemName: "plus.app",
              titleID: .welcomeNewMachineTitle,
              descriptionID: .welcomeNewMachineDescription
            ) {
              Windows.showNewDocumentWindow(ofType: .virtualMachine)
            }

            WelcomeActionButton(
              imageSystemName: "square.and.arrow.down",
              titleID: .welcomeExistingMachineTitle,
              descriptionID: .welcomeExistingMachineDescription
            ) {
              self.openDocumentIsVisible = true
            }
            .fileImporter(
              isPresented: self.$openDocumentIsVisible,
              allowedContentTypes: [UTType.virtualMachine]
            ) { result in
              if let url = try? result.get() {
                Windows.openDocumentAtURL(url)
              }
            }

            WelcomeActionButton(
              imageSystemName: "server.rack",
              titleID: .welcomeStartLibraryTitle,
              descriptionID: .welcomeStartLibraryDescription
            ) {
              Windows.showNewSavedDocumentWindow(ofType: RestoreImageLibraryDocument.self)
            }

            WelcomeActionButton(
              imageSystemName: "square.and.arrow.down.on.square",
              titleID: .welcomeDownloadImageTitle,
              descriptionID: .welcomeDownloadImageDescription
            ) {
              Windows.openWindow(withHandle: BasicWindowOpenHandle.remoteSources)
            }
          }
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
