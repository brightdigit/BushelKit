//
// HubDetailView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelHub
  import SwiftUI

  struct HubDetailView: View {
    let image: HubImage?
    @Environment(\.librarySystemManager) var librarySystemManager
    var body: some View {
      if let image {
        VStack(alignment: .leading, spacing: 4.0) {
          let label = librarySystemManager.labelForSystem(
            image.metadata.vmSystem,
            metadata: image.metadata
          )
          VStack(alignment: .leading) {
            Text(image.title).font(.system(.title)).fontWeight(.bold).padding(.vertical, 4)
            Text(label.operatingSystemLongName).font(.subheadline)
          }.padding(.vertical, 4)
          VStack(alignment: .leading) {
            Text("Last Modified").fontWeight(.light)
            Text(image.metadata.lastModified, style: .date)
          }
          VStack(alignment: .leading) {
            Text("Size").fontWeight(.light)
            Text(Int64(image.metadata.contentLength), format: .byteCount(style: .file)).font(.caption)
          }

          VStack(alignment: .leading) {
            Text("URL").fontWeight(.light)

            Text(image.url, format: .url).font(.caption2)
          }
          Spacer()
        }.padding()
      } else {
        Text("None Selected")
      }
    }
  }

  #Preview {
    HubDetailView(image: nil)
  }
#endif
