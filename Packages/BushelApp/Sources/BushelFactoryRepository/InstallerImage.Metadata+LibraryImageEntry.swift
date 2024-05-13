//
// InstallerImage.Metadata+LibraryImageEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelData
  import BushelFactory
  import BushelLibrary
  import BushelMachine
  import Foundation

  extension InstallerImage.Metadata {
    internal init(
      entry: LibraryImageEntry,
      _ labelProvider: @escaping MetadataLabelProvider
    ) {
      let imageMetadata = ImageMetadata(entry: entry)
      self.init(labelName: entry.name, imageMetadata: imageMetadata, labelProvider)
    }
  }
#endif
