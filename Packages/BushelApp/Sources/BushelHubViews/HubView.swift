//
// HubView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore

  import BushelHub
  import BushelHubEnvironment

  public import SwiftUI

  @MainActor
  public struct HubView: View {
    @Environment(\.hubs) private var hubs
    @Environment(\.dismiss) private var dismiss
    @Binding private var selectedHubImage: (any InstallImage)?
    @State private var object: HubObject
    public var body: some View {
      NavigationSplitView {
        HubSidebarView(
          selectedHubID: self.$object.selectedHubID,
          hubs: self.object.hubs,
          hubImages: self.object.hubImages
        ).navigationSplitViewColumnWidth(150)
      } content: {
        HubContentView(
          hubID: self.object.selectedHubID,
          images: self.object.images,
          selectedImageID: self.$object.selectedImageID
        ).navigationSplitViewColumnWidth(250)
      } detail: {
        HubDetailView(image: self.object.selectedImage)
      }
      .frame(width: 800, height: 400)
      .toolbar(content: {
        ToolbarItemGroup {
          Button("Cancel") {
            dismiss()
          }
          Button("Add Image") {
            self.selectedHubImage = self.object.selectedImage
            dismiss()
          }.disabled(self.object.selectedImage == nil)
        }
      })
      .onAppear(perform: {
        self.object.hubs = self.hubs
      })
    }

    private init(selectedHubImage: Binding<(any InstallImage)?>, object: HubObject) {
      self._selectedHubImage = selectedHubImage
      self._object = .init(wrappedValue: object)
    }

    public init(selectedHubImage: Binding<(any InstallImage)?>) {
      self.init(selectedHubImage: selectedHubImage, object: .init())
    }
  }
#endif
