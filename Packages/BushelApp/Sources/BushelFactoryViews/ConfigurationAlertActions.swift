//
// ConfigurationAlertActions.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLocalization
  import BushelViewsCore
  public import SwiftUI

  public struct ConfigurationAlertActions: View {
    private let destinationURL: () -> URL?
    private let onCompleted: () -> Void
    public var body: some View {
      if let destinationURL = self.destinationURL() {
        Button(role: .destructive, LocalizedStringID.machineInstallErrorDeleteYes) {
          do {
            try FileManager.default.removeItem(at: destinationURL)
          } catch {
            assertionFailure(error: error)
          }
          self.onCompleted()
        }
      }

      Button(.machineInstallErrorDeleteNo) {
        self.onCompleted()
      }
    }

    public init(
      destinationURL: @autoclosure @escaping () -> URL?,
      onCompleted: @escaping () -> Void
    ) {
      self.destinationURL = destinationURL
      self.onCompleted = onCompleted
    }
  }
#endif
