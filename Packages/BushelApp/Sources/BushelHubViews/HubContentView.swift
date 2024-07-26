//
// HubContentView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore

  public import BushelHub
  import BushelLibraryEnvironment
  import BushelLocalization

  public import SwiftUI

  internal struct HubContentView: View {
    private let hubID: String?
    private let images: [HubImage]?
    @Environment(\.librarySystemManager) private var librarySystemManager
    @Binding private var selectedImageID: HubImage.ID?

    internal var body: some View {
      if self.hubID == nil {
        Text(.hubNoneSelected)
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

    internal init(
      hubID: String?,
      images: [HubImage]?,
      selectedImageID: Binding<HubImage.ID?>
    ) {
      self.hubID = hubID
      self.images = images
      self._selectedImageID = selectedImageID
    }
  }
#endif
