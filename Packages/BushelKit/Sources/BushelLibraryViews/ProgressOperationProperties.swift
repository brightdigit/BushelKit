//
// ProgressOperationProperties.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Observation) && os(macOS)
  import BushelCore
  import BushelLibrary
  import BushelProgressUI
  import Foundation

  public extension ProgressOperationProperties {
    init(system: LibrarySystem, metadata: ImageMetadata, operation: any ProgressOperation<Int>) {
      self.init(
        imageName: system.imageName(for: metadata),
        text: system.operatingSystemLongName(for: metadata),
        progress: .init(operation)
      )
    }
  }
#endif
