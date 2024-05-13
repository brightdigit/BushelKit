//
// InstallerView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import BushelMachine
  import SwiftUI

  public struct InstallerView: View, Loggable {
    @Environment(\.dismiss) private var dismiss
    @Binding private var buildResult: Result<URL, BuilderError>?
    private var installationObject: InstallerObject

    public var body: some View {
      VStack {
        Image
          .resource("Logo-Monochrome")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 50.0)
          .padding(20.0)
        ProgressView(value: installationObject.percentCompleted).tint(.white)
      }
      .padding(100.0)
      .padding(.horizontal, 100)
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
      percentCompleted: Double = 0.0
    ) {
      self.init(
        buildResult: buildResult,
        installationObject: .init(builder: builder, percentCompleted: percentCompleted)
      )
    }
  }

//  #Preview {
//    MachineInstallationView(builder: PreviewMachineBuilder())
//  }
#endif
