//
// MetadataLabelProviderAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  public import BushelCore

  import Foundation

  public import SwiftUI

  private struct MetadataLabelProviderKey: EnvironmentKey {
    typealias Value = MetadataLabelProviderAction

    static let defaultValue: MetadataLabelProviderAction = .default
  }

  public struct MetadataLabelProviderAction: Sendable {
    static let `default` = MetadataLabelProviderAction(closure: MetadataLabel.init)
    let closure: BushelCore.MetadataLabelProvider

    @Sendable
    public func callAsFunction(
      _ vmSystemID: VMSystemID,
      _ operatingSystemInfo: any OperatingSystemInstalled
    ) -> MetadataLabel {
      closure(vmSystemID, operatingSystemInfo)
    }
  }

  extension MetadataLabel {
    @Sendable
    fileprivate init(_: VMSystemID, _: any OperatingSystemInstalled) {
      self.init()
    }

    @Sendable
    fileprivate init() {
      self.init(
        operatingSystemLongName: "",
        defaultName: "",
        imageName: "",
        systemName: "",
        versionName: ""
      )
    }
  }

  extension EnvironmentValues {
    public var metadataLabelProvider: MetadataLabelProviderAction {
      get { self[MetadataLabelProviderKey.self] }
      set { self[MetadataLabelProviderKey.self] = newValue }
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  extension View {
    public func metadataLabelProvider(
      _ closure: @escaping BushelCore.MetadataLabelProvider
    ) -> some View {
      self.environment(\.metadataLabelProvider, .init(closure: closure))
    }
  }

  extension Scene {
    public func metadataLabelProvider(
      _ closure: @escaping BushelCore.MetadataLabelProvider
    ) -> some Scene {
      self.environment(\.metadataLabelProvider, .init(closure: closure))
    }
  }
#endif
