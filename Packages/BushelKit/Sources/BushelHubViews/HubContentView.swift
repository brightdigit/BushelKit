//
// HubContentView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelHub
  import BushelLibraryEnvironment
  import BushelLocalization
  import SwiftUI

  struct HubContentView: View {
    internal init(
      hubID: String?,
      images: [HubImage]?,
      selectedImageID: Binding<HubImage.ID?>
    ) {
      self.hubID = hubID
      self.images = images
      self._selectedImageID = selectedImageID
    }

    let hubID: String?
    let images: [HubImage]?
    @Environment(\.librarySystemManager) var librarySystemManager
    @Binding var selectedImageID: HubImage.ID?

    var body: some View {
      if self.hubID == nil {
        Text("None Selected")
      } else if let images {
        List(selection: self.$selectedImageID) {
          ForEach(images) { image in
            HubContentRow(manager: librarySystemManager, metadata: image.metadata)
          }
        }
      } else {
        ProgressView()
      }
    }
  }
#endif
