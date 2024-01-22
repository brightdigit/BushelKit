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

    static var defaultValue: MetadataLabelProviderAction = .default
  }

  public struct MetadataLabelProviderAction {
    static let `default` = MetadataLabelProviderAction(closure: MetadataLabel.init)
    let closure: BushelCore.MetadataLabelProvider
    public func callAsFunction(
      _ vmSystemID: VMSystemID,
      _ operatingSystemInfo: any OperatingSystemInstalled
    ) -> MetadataLabel {
      closure(vmSystemID, operatingSystemInfo)
    }
  }

  private extension MetadataLabel {
    init(_: VMSystemID, _: any OperatingSystemInstalled) {
      self.init()
    }

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
