//
// RestoreImagesObject.swift
// Copyright (c) 2022 BrightDigit.
//

import BushelMachine

#if canImport(SwiftUI)
  import Foundation

  class ApplicationContext: ObservableObject {
    internal init(
      images: [RestoreImageContext] = [],
      machines: [MachineContext] = [],
      libraries: [RestoreImageLibraryContext] = []
    ) {
      self.images = images
      self.machines = machines
      self.libraries = libraries
    }

    @Published var images: [RestoreImageContext]
    @Published var machines: [MachineContext]
    @Published var libraries: [RestoreImageLibraryContext]
  }

  class RestoreImagesObject: ObservableObject {
    internal init(
      userDefaults: UserDefaults = .standard,
      recentDocuments: RecentDocumentsObject,
      applicationContext: ApplicationContext = .init()
    ) {
      self.userDefaults = userDefaults
      self.recentDocuments = recentDocuments
      self.applicationContext = applicationContext
    }

    let userDefaults: UserDefaults
    @Published var recentDocuments: RecentDocumentsObject
    @Published var applicationContext: ApplicationContext
  }
#endif
