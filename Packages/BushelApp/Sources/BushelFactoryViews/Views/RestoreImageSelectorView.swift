//
// RestoreImageSelectorView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import SwiftUI

  internal struct RestoreImageSelectorView: View {
    private let releasePrefix: String
    @Binding private var object: BuildConfigurationObject
    @Binding private var isNextReady: Bool

    internal var body: some View {
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

    internal init(
      releasePrefix: String,
      object: Binding<BuildConfigurationObject>,
      isNextReady: Binding<Bool>
    ) {
      self.releasePrefix = releasePrefix
      self._object = object
      self._isNextReady = isNextReady
    }
  }

#endif
