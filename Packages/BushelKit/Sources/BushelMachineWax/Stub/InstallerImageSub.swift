//
// InstallerImageSub.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelCore
import BushelCoreWax
import BushelMachine
import Foundation

public struct InstallerImageSub: InstallerImage {
  public var libraryID: LibraryIdentifier? = .sampleLibraryID

  public var imageID: UUID = .imageIDSample

  public var metadata: Metadata = .init(
    longName: "",
    defaultName: "",
    labelName: "",
    operatingSystem: .init(
      majorVersion: 1,
      minorVersion: 1,
      patchVersion: 1
    ),
    buildVersion: "",
    imageResourceName: "",
    systemName: "",
    systemID: .sampleVMSystemID
  )

  public func getURL() throws -> URL {
    .bushelappURL
  }
}
