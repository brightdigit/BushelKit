//
// MachineView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct MachineView: View {
    @Binding var document: MachineDocument
    @State var validationResult: Result<Void, Error>?
    var url: URL?
    var body: some View {
      Group {
        if let url = self.url {
          VStack {
            switch self.validationResult {
            case .success:
              MachineDetailsView(document: self.$document, url: url)

            case let .failure(error):
              Text(error.localizedDescription).onAppear {
                Self.logger.error("failure gettings machine: \(error.localizedDescription)")
              }

            case .none:
              ProgressView {
                Text(.loadingMachine)
              }
            }
          }
          .onAppear {
            self.validationResult = Result {
              try self.document.validateSessionAt(url)
            }
          }
        }
      }
    }
  }
#endif
