//
// MetadataLabelProviderAction.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  private struct MetadataLabelProviderKey: EnvironmentKey {
    typealias Value = MetadataLabelProviderAction

    static var defaultValue: MetadataLabelProviderAction = .default
  }

  public struct MetadataLabelProviderAction {
    static let `default` = MetadataLabelProviderAction(closure: MetadataLabel.init)
    let closure: BushelCore.MetadataLabelProvider
    public func callAsFunction(_ systemID: VMSystemID, _ metadata: ImageMetadata) -> MetadataLabel {
      closure(systemID, metadata)
    }
  }

  private extension MetadataLabel {
    init(_: VMSystemID, _: ImageMetadata) {
      self.init()
    }

    init() {
      self.init(operatingSystemLongName: "", defaultName: "", imageName: "", systemName: "")
    }
  }

  public extension EnvironmentValues {
    var metadataLabelProvider: MetadataLabelProviderAction {
      get { self[MetadataLabelProviderKey.self] }
      set { self[MetadataLabelProviderKey.self] = newValue }
    }
  }

  public extension Scene {
    func metadataLabelProvider(
      _ closure: @escaping BushelCore.MetadataLabelProvider
    ) -> some Scene {
      self.environment(\.metadataLabelProvider, .init(closure: closure))
    }
  }
#endif
