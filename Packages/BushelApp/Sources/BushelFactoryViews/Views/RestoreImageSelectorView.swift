//
// RestoreImageSelectorView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import SwiftUI

  struct RestoreImageSelectorView: View {
    let releasePrefix: String
    @Binding var object: BuildConfigurationObject
    @Binding var isNextReady: Bool

    var body: some View {
      if let releases = object.releases {
        Form {
          Section {
            VStack {
              ReleaseList(
                releaseSelection: self.$object.releaseSelection,
                releases: releases,
                headerText: releasePrefix
              )

              Picker(
                selection: self.$object.selectedBuildImage
              ) {
                ForEach(object.availableVersions) { item in
                  if let version = item.image {
                    HStack {
                      Text("\(version.metadata.operatingSystem) (\(version.buildVersion ?? ""))")
                    }.tag(item)
                  }
                }
              } label: {
                Text(.machineDialogBuildPicker)
              }
            }
          }
        }
        .onChange(of: self.object.specificationConfiguration, initial: true) { _, newValue in
          self.isNextReady = newValue != nil
        }
      }
    }
  }

#endif
