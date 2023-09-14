//
// HubMasterView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelHub
  import SwiftUI

  struct HubMasterView: View {
    @Binding var selectedHubID: String?
    let hubs: [Hub]
    let hubImages: [Hub.ID: [HubImage]]

    var body: some View {
      List(selection: self.$selectedHubID) {
        ForEach(hubs) { hub in
          NavigationLink(value: hub) {
            HubMasterRow(text: hub.title, count: imageCount(forHub: hub), image: self.image(forHub: hub))
          }
        }
      }
    }

    func imageCount(forHub hub: Hub) -> Int? {
      hubImages[hub.id]?.count ?? hub.count
    }

    func image(forHub _: Hub) -> () -> Image {
      {
        Image(systemName: "square.3.layers.3d")
      }
    }
  }

#endif
