//
// BuildConfigurationObject+Internal.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelFactory
  import BushelMachine
  import Foundation
  import SwiftData

  extension BuildConfigurationObject {
    @discardableResult
    func withError(_ error: any Error) -> ConfigurationError {
      self.withError(.unknownError(error))
    }

    @discardableResult
    func withError(_ error: ConfigurationError) -> ConfigurationError {
      assertionFailure(error: error)
      self.error = error
      return error
    }

    func beginSetupWith(
      systemManager: any MachineSystemManaging,
      releaseCollectionProvider: @escaping ReleaseCollectionMetadataProvider,
      imageRepository: any InstallerImageRepository,
      metadataLabelProvider: @escaping MetadataLabelProvider
    ) {
      self.machineSystem = systemManager.resolve(self.system)
      Task {
        do {
          try await self.setup(
            releaseCollectionProvider: releaseCollectionProvider,
            imageRepository: imageRepository,
            metadataLabelProvider: metadataLabelProvider
          )
        } catch let dbError as SwiftDataError {
          self.error = .databaseError(dbError)
        }
      }
    }

    func buildRequestChangedTo(_ request: MachineBuildRequest?) {
      guard let request else {
        return
      }

      guard releases != nil else {
        self.buildRequest = request
        return
      }
      updateSelection(basedOn: request)
    }

    func presentFileDialog() {
      if self.prepareBuild() {
        self.presentFileExporter = true
      }
    }

    func beginBuild(result: Result<URL, any Error>) {
      let url: URL
      do {
        url = try result.get()
      } catch {
        Self.logger.critical(
          "Unable to create build unknown error: \(self.withError(.fileDialogError(error)))"
        )
        return
      }
      self.beginBuild(at: url)
    }

    func machineURL(fromBuildResult buildResult: Result<URL, BuilderError>?) -> URL? {
      switch buildResult {
      case let .failure(error):
        self.error = .machineBuilderError(error)
        fallthrough

      case .none:
        return nil

      case let .success(url):
        return url
      }
    }

    public func getDestinationURL(assertionFailureIfNil: Bool) -> URL? {
      let destinationDataURL = self.activeBuild?.builder.url ?? self.lastDestinationURL
      if assertionFailureIfNil {
        assert(destinationDataURL != nil)
      }
      return destinationDataURL?.deletingLastPathComponent()
    }
  }
#endif
