//
// InstallerImage.Metadata+LibraryImageEntry.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelData
  import BushelLibrary
  import BushelMachine
  import Foundation
  import SwiftData

  extension InstallerImage.Metadata {
    init(
      entry: LibraryImageEntry,
      _ labelProvider: @escaping MetadataLabelProvider
    ) {
      let imageMetadata = ImageMetadata(entry: entry)
      self.init(labelName: entry.name, imageMetadata: imageMetadata, labelProvider)
    }
  }
#endif
