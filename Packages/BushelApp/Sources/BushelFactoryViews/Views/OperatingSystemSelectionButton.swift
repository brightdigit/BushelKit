//
// OperatingSystemSelectionButton.swift
// Copyright (c) 2024 BrightDigit.
//

//
//  OperatingSystemSelectionButton.swift
//  PageViewController
//
//  Created by Leo Dion on 3/12/24.
//
#if canImport(SwiftUI)
  import BushelFactory
  import BushelLocalization
  import SwiftUI

  struct OperatingSystemSelectionButton: View {
    @Binding var selectedMajorVersion: ReleaseSelected
    let release: ReleaseMetadata

    var isSelected: Bool {
      guard case let .version(value) = selectedMajorVersion else {
        return false
      }

      return value == self.release
    }

    var body: some View {
      Button {
        self.selectedMajorVersion = .version(release)
      } label: {
        VStack(spacing: 10.0) {
          Image.resource(release.metadata.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(.vertical, 4.0)
            .mask { Circle() }
            .overlay { Circle().stroke() }
            .frame(width: 50.0)
            .padding(4.0)
            .background {
              RoundedRectangle(cornerRadius: 4.0).fill(Color.accentColor).opacity(isSelected ? 0.25 : 0.0)
            }
            .padding(-4.0)
          VStack {
            Text(release.metadata.versionName).font(.caption)
            Text(release.metadata.releaseName)
          }
          .padding(4.0)
          .background {
            RoundedRectangle(cornerRadius: 4.0).fill(Color.accentColor).opacity(isSelected ? 1.0 : 0.0)
          }
          .padding(-4.0)
        }.padding()
          .opacity(self.isSelected ? 1.0 : 0.7)
      }
      .buttonStyle(.plain)
      .disabled(release.images.isEmpty)
    }

    init(selectedMajorVersion: Binding<ReleaseSelected>, release: ReleaseMetadata) {
      self._selectedMajorVersion = selectedMajorVersion
      self.release = release
    }
  }

#endif
