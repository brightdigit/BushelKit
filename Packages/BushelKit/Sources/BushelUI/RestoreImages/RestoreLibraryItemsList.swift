//
// RestoreLibraryItemsList.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct RestoreLibraryItemsList: View {
    let activeImports: [ActiveRestoreImageImport]
    let listContainer: RestoreLibraryItemsListable
    @Binding var selectedFileID: UUID?

    var body: some View {
      List {
        if !activeImports.isEmpty {
          ActiveImportList(activeImports: self.activeImports)
        }
        Section {
          ForEach(listContainer.listItems) { item in
            RestoreLibraryNavigationItem(
              item: listContainer.bindingFor(item),
              selectedFileID: self.$selectedFileID
            )
          }
        }
      }
    }
  }
#endif
