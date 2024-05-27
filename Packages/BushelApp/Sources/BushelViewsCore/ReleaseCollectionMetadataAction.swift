//
// ReleaseCollectionMetadataAction.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelCore
  import Foundation
  import SwiftUI

  private enum DefaultReleaseCollectionProvider: ReleaseCollectionMetadata {
    case value
    internal enum InstallerReleaseType: InstallerRelease {
      var majorVersion: Int {
        self.id
      }

      var releaseName: String {
        ""
      }

      var versionName: String {
        ""
      }

      var imageName: String {
        ""
      }

      var id: Int {
        -1
      }
    }

    var releases: [InstallerReleaseType] {
      []
    }

    var customVersionsAllowed: Bool {
      false
    }

    var prefix: String {
      ""
    }

    @Sendable
    static func closure(_: VMSystemID) -> any ReleaseCollectionMetadata {
      DefaultReleaseCollectionProvider.value
    }
  }

  private struct ReleaseCollectionMetadataActionKey: EnvironmentKey {
    typealias Value = ReleaseCollectionMetadataAction

    static let defaultValue: ReleaseCollectionMetadataAction = .default
  }

  public struct ReleaseCollectionMetadataAction: Sendable {
    static let `default` = ReleaseCollectionMetadataAction(
      closure: DefaultReleaseCollectionProvider.closure(_:)
    )
    let closure: BushelCore.ReleaseCollectionMetadataProvider

    @Sendable
    public func callAsFunction(
      _ vmSystemID: VMSystemID
    ) -> any ReleaseCollectionMetadata {
      closure(vmSystemID)
    }
  }

  extension EnvironmentValues {
    public var releaseCollectionProvider: ReleaseCollectionMetadataAction {
      get { self[ReleaseCollectionMetadataActionKey.self] }
      set { self[ReleaseCollectionMetadataActionKey.self] = newValue }
    }
  }

  extension Scene {
    public func releaseCollectionProvider(
      _ closure: @escaping BushelCore.ReleaseCollectionMetadataProvider
    ) -> some Scene {
      self.environment(\.releaseCollectionProvider, .init(closure: closure))
    }
  }
#endif
