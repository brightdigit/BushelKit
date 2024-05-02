//
// ReleaseCollectionMetadata.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol ReleaseCollectionMetadata: Sendable {
  associatedtype InstallerReleaseType: InstallerRelease
  var releases: [InstallerReleaseType] { get }
  var customVersionsAllowed: Bool { get }
  var prefix: String { get }
}
