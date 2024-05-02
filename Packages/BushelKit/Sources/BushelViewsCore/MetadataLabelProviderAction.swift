//
// MetadataLabelProviderAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

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

  private extension MetadataLabel {
    @Sendable
    init(_: VMSystemID, _: any OperatingSystemInstalled) {
      self.init()
    }

    @Sendable
    init() {
      self.init(
        operatingSystemLongName: "",
        defaultName: "",
        imageName: "",
        systemName: "",
        versionName: ""
      )
    }
  }

  public extension EnvironmentValues {
    var metadataLabelProvider: MetadataLabelProviderAction {
      get { self[MetadataLabelProviderKey.self] }
      set { self[MetadataLabelProviderKey.self] = newValue }
    }
  }

  @available(*, deprecated, message: "Use on Scene only.")
  public extension View {
    func metadataLabelProvider(
      _ closure: @escaping BushelCore.MetadataLabelProvider
    ) -> some View {
      self.environment(\.metadataLabelProvider, .init(closure: closure))
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
