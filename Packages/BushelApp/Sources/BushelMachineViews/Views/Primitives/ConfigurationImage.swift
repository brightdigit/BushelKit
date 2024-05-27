//
// ConfigurationImage.swift
// Copyright (c) 2024 BrightDigit.
//

import BushelCore
import BushelMachine
import Foundation

internal struct ConfigurationImage: Identifiable {
  let installerImage: any InstallerImage

  var id: UUID {
    installerImage.imageID
  }

  var libraryID: LibraryIdentifier? {
    installerImage.libraryID
  }

  var metadata: InstallerImageMetadata {
    installerImage.metadata
  }
}
