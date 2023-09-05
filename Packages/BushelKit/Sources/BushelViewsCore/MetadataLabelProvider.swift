//
// MetadataLabelProvider.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  private struct MetadataLabelProviderKey: EnvironmentKey {
    typealias Value = MetadataLabelProvider

    static var defaultValue: MetadataLabelProvider = .default
  }

  public struct MetadataLabelProvider {
    static let `default` = MetadataLabelProvider(closure: { _, _ in .init(operatingSystemLongName: "", defaultName: "", imageName: "") })
    let closure: (VMSystemID, ImageMetadata) -> MetadataLabel
    public func callAsFunction(_ systemID: VMSystemID, _ metadata: ImageMetadata) -> MetadataLabel {
      closure(systemID, metadata)
    }
  }

  public extension EnvironmentValues {
    var metadataLabelProvider: MetadataLabelProvider {
      get { self[MetadataLabelProviderKey.self] }
      set { self[MetadataLabelProviderKey.self] = newValue }
    }
  }

  public extension Scene {
    func metadataLabelProvider(
      _ closure: @escaping (VMSystemID, ImageMetadata) -> MetadataLabel
    ) -> some Scene {
      self.environment(\.metadataLabelProvider, .init(closure: closure))
    }
  }
#endif
