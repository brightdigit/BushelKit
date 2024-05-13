//
// ProgressOperationProperties.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  import BushelCore
  import BushelLibrary
  import BushelProgressUI
  import Foundation

  extension ProgressOperationProperties {
    public init(system: any LibrarySystem, metadata: ImageMetadata, operation: any ProgressOperation<Int>) {
      let label = system.label(fromMetadata: metadata)
      self.init(
        imageName: label.imageName,
        text: label.operatingSystemLongName,
        progress: .init(operation)
      )
    }
  }
#endif
