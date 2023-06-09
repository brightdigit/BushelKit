//
// ApplicationContext.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import FelinePine

#if canImport(SwiftUI)
  import AppKit
  import Combine
  import Foundation
  import HarvesterKit
  import UniformTypeIdentifiers

  class ApplicationContext: ObservableObject, LoggerCategorized {
    static let loggingCategory = LoggerCategory.reactive
    // swiftlint:disable:next implicitly_unwrapped_optional
    static var shared: ApplicationContext!

    @Published var images: Set<RestoreImageContext>
    @Published var machines: Set<MachineContext>
    @Published var libraries: Set<RestoreImageLibraryContext>
    let userDefaults: UserDefaults
    @Published var recentDocumentURLs: [URL]
    @Published var allDocuments = Set<URL>()

    var documentController: NSDocumentController?
    var cancellables = [AnyCancellable]()

    let refreshSubject = PassthroughSubject<Void, Never>()

    internal init(
      userDefaults: UserDefaults = Configuration.userDefaults,
      recentDocumentURLs: [URL] = [],
      isPreview: Bool = false,
      images: [RestoreImageContext]? = nil,
      machines: [MachineContext]? = nil,
      libraries: [RestoreImageLibraryContext]? = nil
    ) {
      self.images = Set(userDefaults.decode(from: Self.self, override: images))
      self.machines = Set(userDefaults.decode(from: Self.self, override: machines))
      self.libraries = Set(userDefaults.decode(from: Self.self, override: libraries))

      self.userDefaults = userDefaults
      self.recentDocumentURLs = recentDocumentURLs

      guard !isPreview else {
        return
      }

      precondition(Self.shared == nil)
      Self.shared = self

      beginListeningDocumentController()

      setupPublishers()
    }

    // swiftlint:disable:next function_body_length
    func assignDocumentURLs<Upstream: Publisher>(
      _ publisher: Upstream,
      onFailure: @escaping (URL, Error) -> Void
    ) where Upstream.Output == DocumentURL, Upstream.Failure == Never {
      let typedURLs = publisher.share()

      typedURLs
        .map(
          MachineContext.self,
          onFailure: onFailure
        )
        .union(machines)
        .receive(on: DispatchQueue.main)
        .assign(to: &$machines)

      let libraryURLs = typedURLs
        .map(
          RestoreImageLibraryExtraction.self,
          onFailure: onFailure
        )
        .share()

      libraryURLs
        .map(\.context)
        .union(libraries)
        .receive(on: DispatchQueue.main)
        .assign(to: &$libraries)

      libraryURLs
        .map(\.imageConexts)
        .union(images)
        .receive(on: DispatchQueue.main)
        .assign(to: &$images)
    }

    // swiftlint:disable:next function_body_length
    func setupPublishers() {
      refreshSubject
        .delay(for: .seconds(1), tolerance: .seconds(1), scheduler: DispatchQueue.global())
        .compactMap { self.documentController?.recentDocumentURLs }
        .receive(on: DispatchQueue.main)
        .assign(to: &$recentDocumentURLs)

      $recentDocumentURLs
        .union(allDocuments)
        .receive(on: DispatchQueue.main)
        .assign(to: &$allDocuments)

      let allDocumentsPublisher = $allDocuments.share()

      let typedURLs = allDocumentsPublisher
        .map { urls in urls.publisher }
        .switchToLatest()
        .tryMap(DocumentURL.init(url:), onFailure: { url, error in
          Self.logger.error("couldn't accept \(url): \(error.localizedDescription)")
        })

      assignDocumentURLs(typedURLs) { _, error in
        Self.logger.error("unable to load context from url: \(error.localizedDescription)")
      }

      var encoder = UserDefaultsEncoder()

      encoder.append($libraries.encodeResult())
      encoder.append($machines.encodeResult())
      encoder.append($images.encodeResult())

      encoder(
        userDefaults.setData(_:),
        onFailure: { error in
          Self.logger.error("Encoding Error: \(error.localizedDescription)")
        },
        storeIn: &cancellables
      )
    }

    func beginListeningDocumentController() {
      #warning("Swap for MainActor")
      DispatchQueue.main.async {
        let documentController = NSDocumentController.shared
        documentController
          .publisher(for: \.recentDocumentURLs)
          .receive(on: DispatchQueue.main)
          .assign(to: &self.$recentDocumentURLs)
        self.recentDocumentURLs = documentController.recentDocumentURLs
        self.documentController = documentController
      }
    }

    func clearRecentDocuments() {
      documentController?.clearRecentDocuments(self)
      refreshRecentDocuments()
    }

    func refreshRecentDocuments() {
      Self.logger.debug("refresh documents called")
      refreshSubject.send()
    }
  }

#endif
