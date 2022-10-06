//
// ApplicationContext.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine

#if canImport(SwiftUI)
  import AppKit
  import Combine
  import Foundation
  import UniformTypeIdentifiers

  class ApplicationContext: ObservableObject, LoggerCategorized {
    static let loggingCategory = LoggerCategory.reactive
    static var shared: ApplicationContext!

    // swiftlint:disable:next function_body_length
    fileprivate func setupPublishers() {
      refreshSubject.delay(for: .seconds(1), tolerance: .seconds(1), scheduler: DispatchQueue.global()).compactMap {
        self.documentController?.recentDocumentURLs
      }.receive(on: DispatchQueue.main).assign(to: &$recentDocumentURLs)

      $recentDocumentURLs
        .map { newURLS in
          self.allDocuments.union(newURLS)
        }
        .receive(on: DispatchQueue.main)
        .assign(to: &$allDocuments)

      let allDocumentsPublisher = $allDocuments.share()

      let typedURLs = allDocumentsPublisher
        .map { urls in
          urls.publisher
        }
        .switchToLatest()
        .tryMap(DocumentURL.init(url:), onFailure: { url, error in
          Self.logger.error("couldn't accept \(url): \(error.localizedDescription)")
        })
        .share()

      typedURLs.compactMap {
        $0.type == .machine ? $0.url : nil
      }
      .tryMap(Machine.loadFromURL, onFailure: { url, error in
        Self.logger.error("unable to load machine from \(url): \(error.localizedDescription)")
      })
      .tryMap(MachineContext.init, onFailure: { _, error in
        Self.logger.error("unable to load context from machine: \(error.localizedDescription)")
      })
      .map { machineContext in
        self.machines.union([machineContext])
      }.receive(on: DispatchQueue.main)
      .assign(to: &$machines)

      let libraryURLs = typedURLs.compactMap {
        $0.type == .library ? $0.url : nil
      }
      .tryMap({ (url: URL) -> (RestoreImageLibraryContext, RestoreImageLibrary) in
        let restoreLibrary: RestoreImageLibrary
        let data = try Data(contentsOf: url.appendingPathComponent("metadata.json"))
        restoreLibrary = try Configuration.JSON.tryDecoding(data)
        return (RestoreImageLibraryContext(url: url), restoreLibrary)
      }, onFailure: { _, error in
        Self.logger.error("\(error.localizedDescription)")
      }).share()

      libraryURLs.map { context, _ in
        self.libraries.union([context])
      }.receive(on: DispatchQueue.main).assign(to: &$libraries)

      libraryURLs.map { context, library in
        library.items.map { file in
          RestoreImageContext(library: context, file: file)
        }
      }.map { images in
        self.images.union(images)
      }.receive(on: DispatchQueue.main).assign(to: &$images)
    }

    fileprivate func beginListeningDocumentController() {
      DispatchQueue.main.async {
        let documentController = NSDocumentController.shared
        documentController.publisher(for: \.recentDocumentURLs).receive(on: DispatchQueue.main).assign(to: &self.$recentDocumentURLs)
        self.recentDocumentURLs = documentController.recentDocumentURLs
        self.documentController = documentController
      }
    }

    internal init(
      userDefaults: UserDefaults = Configuration.userDefaults,
      recentDocumentURLs: [URL] = [],
      isPreview: Bool = false,
      images: [RestoreImageContext] = [],
      machines: [MachineContext] = [],
      libraries: [RestoreImageLibraryContext] = []
    ) {
      self.images = Set(images)
      self.machines = Set(machines)
      self.libraries = Set(libraries)
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

    @Published var images: Set<RestoreImageContext>
    @Published var machines: Set<MachineContext>
    @Published var libraries: Set<RestoreImageLibraryContext>
    let userDefaults: UserDefaults
    @Published var recentDocumentURLs: [URL]
    @Published var allDocuments = Set<URL>()

    // swiftlint:disable:next implicitly_unwrapped_optional
    var documentController: NSDocumentController?
    var cancellables = [AnyCancellable]()

    let refreshSubject = PassthroughSubject<Void, Never>()

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
