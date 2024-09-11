//
// HubContentRow.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelLibrary
  import BushelLocalization
  import RadiantKit

  public import SwiftUI

  public struct HubContentRow: View {
    private let label: MetadataLabel

    public var body: some View {
      PreferredLayout.View { value in
        HStack {
          Image.resource(label.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.vertical, 4.0)
            .frame(height: value.get())
            .mask { Circle() }
            .overlay { Circle().stroke() }
          VStack(alignment: .leading) {
            Text(label.defaultName).font(.system(size: 16)).lineLimit(1)
            Text(label.operatingSystemLongName).font(.system(size: 11)).lineLimit(1)
          }.apply(\.size.height, with: value)
        }
      }
    }

    internal init(label: MetadataLabel) {
      self.label = label
    }
  }

  extension HubContentRow {
    internal init(manager: any LibrarySystemManaging, metadata: ImageMetadata) {
      let label = manager.labelForSystem(
        metadata.vmSystemID,
        metadata: metadata
      )
      self.init(label: label)
    }
  }
#endif
