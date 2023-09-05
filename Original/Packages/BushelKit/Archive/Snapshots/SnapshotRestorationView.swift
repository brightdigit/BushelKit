//
// SnapshotRestorationView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelReactive
  import SwiftUI

  struct SnapshotRestorationView: View {
    @StateObject var restoration = SnapshotRestorationObject()
    @State var error: GlobalizedError?
    @State var alertShouldPresent = false
    @Environment(\.dismiss) var dismiss: DismissAction
    var body: some View {
      ProgressView("Restoring Snapshot...")
        .alert(
          isPresented: self.$alertShouldPresent,
          error: error, actions: { _ in
            Button("OK") {
              self.dismiss()
            }
          }, message: { error in
            Text(
              String(
                format: NSLocalizedString("There was an error restoring the snapshot: %@", bundle: .module, comment: ""),
                error.localizedDescription
              )
            )
          }
        )
        .padding()
        .onOpenURL { externalURL in
          let snapshotPath: SnapshotPath

          do {
            guard let ssPath = try SnapshotPath(externalURL: externalURL) else {
              Self.logger.error("URL is invalid: \(externalURL)")
              return
            }
            snapshotPath = ssPath
          } catch {
            Self.logger.error("Unable to parse url: \(error.localizedDescription)")
            return
          }
          restoration.beginRestoring(snapshotPath)
        }.onReceive(self.restoration.$result) { result in
          if let result = result {
            switch result {
            case let .success(url):
              Windows.openDocumentAtURL(url)
              self.dismiss()

            case let .failure(error):
              Self.logger.error("Couldn't restore snapshot: \(error.localizedDescription)")
              self.error = error
            }
          }
        }
    }
  }

  struct SnapshotRestorationView_Previews: PreviewProvider {
    static var previews: some View {
      SnapshotRestorationView()
    }
  }
#endif
