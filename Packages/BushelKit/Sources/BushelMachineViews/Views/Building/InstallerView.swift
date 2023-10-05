//
// InstallerView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLogging
  import BushelMachine
  import SwiftUI

  struct InstallerView: View, LoggerCategorized {
    @Environment(\.dismiss) var dismiss
    @Binding var buildResult: Result<URL, BuildError>?
    var installationObject: InstallerObject

    var body: some View {
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
      .task {
        let buildResult = await Result {
          try await self.installationObject.build()
        }
        .map { self.installationObject.url.deletingLastPathComponent() }
        .mapError(BuildError.init(innerError:))

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

    internal init(buildResult: Binding<Result<URL, BuildError>?>, installationObject: InstallerObject) {
      self._buildResult = buildResult
      self.installationObject = installationObject
    }

    init(
      buildResult: Binding<Result<URL, BuildError>?>,
      builder: MachineBuilder,
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