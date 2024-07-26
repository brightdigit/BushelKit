//
// HubSidebarView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  public import BushelCore

  public import BushelHub

  public import SwiftUI

  internal struct HubSidebarView: View {
    @Binding private var selectedHubID: String?
    private let hubs: [Hub]
    private let hubImages: [Hub.ID: [HubImage]]

    internal var body: some View {
      List(selection: self.$selectedHubID) {
        ForEach(hubs) { hub in
          NavigationLink(value: hub) {
            HubSidebarRow(text: hub.title, count: imageCount(forHub: hub), image: self.image(forHub: hub))
          }
        }
      }
    }

    internal init(selectedHubID: Binding<String?>, hubs: [Hub], hubImages: [Hub.ID: [HubImage]]) {
      self._selectedHubID = selectedHubID
      self.hubs = hubs
      self.hubImages = hubImages
    }

    private func imageCount(forHub hub: Hub) -> Int? {
      hubImages[hub.id]?.count ?? hub.count
    }

    private func image(forHub _: Hub) -> () -> Image {
      {
        Image(systemName: "square.3.layers.3d")
      }
    }
  }

#endif
