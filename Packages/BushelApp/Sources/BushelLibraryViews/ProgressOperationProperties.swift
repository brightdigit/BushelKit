//
// ProgressOperationProperties.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(Observation) && (os(macOS) || os(iOS))
  public import BushelCore

  public import BushelLibrary

  import Foundation

  public import RadiantProgress

  extension ProgressOperationProperties {
    @MainActor
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
