//
// RestoreLibraryNavigationItem.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct RestoreLibraryNavigationItem: View {
    @Binding var item: RestoreImageLibraryItemFile
    @Binding var selectedFileID: UUID?
    var body: some View {
      NavigationLink(
        tag: item.id,
        selection: $selectedFileID
      ) {
        VStack {
          RestoreImageLibraryItemFileView(file: $item).padding()
          Spacer()
        }
      } label: {
        Text(item.name)
      }
    }
  }
#endif
