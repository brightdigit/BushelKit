//
// ConfigurationAlertActions.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import SwiftUI

  struct ConfigurationAlertActions: View {
    let destinationURL: () -> URL?
    let onCompleted: () -> Void
    var body: some View {
      if let destinationURL = self.destinationURL() {
        Button("Yes, Delete the Machine.", role: .destructive) {
          do {
            try FileManager.default.removeItem(at: destinationURL)
          } catch {
            assertionFailure(error: error)
          }
          self.onCompleted()
        }
      }

      Button("No keep the failed machine file.") {
        self.onCompleted()
      }
    }

    internal init(
      destinationURL: @autoclosure @escaping () -> URL?,
      onCompleted: @escaping () -> Void
    ) {
      self.destinationURL = destinationURL
      self.onCompleted = onCompleted
    }
  }
#endif
