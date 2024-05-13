//
// ReleaseList.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelFactory
  import BushelLocalization
  import SwiftUI

  internal struct ReleaseList: View {
    @Binding private var releaseSelection: ReleaseSelected
    private let releases: ReleaseCollection
    private let headerText: String
    internal var body: some View {
      LabeledContent(headerText) {
        HStack {
          ForEach(releases.releases) { release in
            if !release.isCustom {
              OperatingSystemSelectionButton(selectedMajorVersion: self.$releaseSelection, release: release)
            }
          }
          Spacer()
          if releases.containsCustomVersions {
            Button {
              self.releaseSelection = .custom
            } label: {
              VStack {
                Image(systemName: "paperclip.badge.ellipsis")
                  .resizable()
                  .aspectRatio(contentMode: .fit)
                  .padding(.vertical, 4.0)
                  .frame(width: 50.0)
                Text(.machineDialogReleaseCustom)
              }.opacity(0.9)
            }.buttonStyle(.plain)
          }
        }.padding(.horizontal).overlay {
          Rectangle()
            .fill(.clear)
            .stroke(.primary.opacity(0.25))
            .shadow(color: .black, radius: 2, x: 1, y: 1)
        }
      }
    }

    internal init(
      releaseSelection: Binding<ReleaseSelected>,
      releases: ReleaseCollection,
      headerText: String
    ) {
      self._releaseSelection = releaseSelection
      self.releases = releases
      self.headerText = headerText
    }
  }

//  #Preview {
//    ReleaseListView()
//  }
#endif
