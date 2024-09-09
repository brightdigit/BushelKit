//
// InstallerView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore

  public import BushelLogging

  public import BushelMachine

  public import SwiftUI

  @MainActor
  public struct InstallerView: View, Loggable, Sendable {
    @Environment(\.dismiss) private var dismiss
    @Binding private var buildResult: Result<URL, BuilderError>?
    private var installationObject: InstallerObject
    let scale: Double = 1.0

    public var body: some View {
      VStack {
        Image
          .resource("Logo-Monochrome")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 50.0 * scale)
          .padding(20.0 * scale)
        ProgressView(value: installationObject.fractionCompleted)
        Text(
          localizedUsingID: installationObject.textLocalizedID,
          arguments: installationObject.percentTextValue
        ).font(.caption)
      }
      .tint(.white)
      .padding(100.0 * scale)
      .padding(.horizontal, 100 * scale)
      .background(Color.black)
      .onAppear {}
      .task { @Sendable in
        let buildResult = await Result {
          try await self.installationObject.build()
        }
        .map { self.installationObject.url.deletingLastPathComponent() }
        .mapError(BuilderError.fromInstallation)

        switch buildResult {
        case let .success(url):
          Self.logger.debug("Finished building VM at \(url)")
          await Task.sleepForSecondsBetween(10, and: 20) { error in
            Self.logger.error("Unable to sleep: \(error.localizedDescription)")
          }
        case let .failure(error):
          Self.logger.error("Error building VM: \(error)")
        }

        self.buildResult = buildResult
        self.dismiss()
      }
    }

    internal init(buildResult: Binding<Result<URL, BuilderError>?>, installationObject: InstallerObject) {
      self._buildResult = buildResult
      self.installationObject = installationObject
    }

    public init(
      buildResult: Binding<Result<URL, BuilderError>?>,
      builder: any MachineBuilder,
      fractionCompleted: Double? = nil
    ) {
      self.init(
        buildResult: buildResult,
        installationObject: .init(builder: builder, fractionCompleted: fractionCompleted)
      )
    }
  }

//  #Preview {
//    MachineInstallationView(builder: PreviewMachineBuilder())
//  }
#endif
