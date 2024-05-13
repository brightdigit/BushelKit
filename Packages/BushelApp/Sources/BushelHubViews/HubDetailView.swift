//
// HubDetailView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelHub
  import SwiftUI

  internal struct HubDetailView: View {
    private let image: HubImage?
    @Environment(\.librarySystemManager) private var librarySystemManager
    internal var body: some View {
      if let image {
        VStack(alignment: .leading, spacing: 4.0) {
          let label = librarySystemManager.labelForSystem(
            image.metadata.vmSystemID,
            metadata: image.metadata
          )
          VStack(alignment: .leading) {
            Text(image.title).font(.system(.title)).fontWeight(.bold).padding(.vertical, 4)
            Text(label.operatingSystemLongName).font(.subheadline)
          }.padding(.vertical, 4)
          VStack(alignment: .leading) {
            Text(.hubLastModified).fontWeight(.light)
            Text(image.metadata.lastModified, style: .date)
          }
          VStack(alignment: .leading) {
            Text(.hubImageSize).fontWeight(.light)
            Text(Int64(image.metadata.contentLength), format: .byteCount(style: .file)).font(.caption)
          }

          VStack(alignment: .leading) {
            Text(.hubURL).fontWeight(.light)

            Text(image.url, format: .url).font(.caption2)
          }
          Spacer()
        }.padding()
      } else {
        Text(.hubNoneSelected)
      }
    }

    internal init(image: HubImage? = nil) {
      self.image = image
    }
  }

  #Preview {
    HubDetailView(image: nil)
  }
#endif
