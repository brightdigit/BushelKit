//
// HubContentRow.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import SwiftUI

  public struct HubContentRow: View {
    internal init(label: MetadataLabel) {
      self.label = label
    }

    let label: MetadataLabel

    public var body: some View {
      HStack {
        #warning("fix image")
        Image(systemName: "photo.fill").imageScale(.medium)
        VStack(alignment: .leading) {
          Text(label.defaultName).font(.system(size: 16)).lineLimit(1)
          Text(label.operatingSystemLongName).font(.system(size: 11)).lineLimit(1)
        }
      }
    }
  }

  extension HubContentRow {
    init(manager: any LibrarySystemManaging, metadata: ImageMetadata) {
      let label = manager.labelForSystem(
        metadata.vmSystem,
        metadata: metadata
      )
      self.init(label: label)
    }
  }
#endif
