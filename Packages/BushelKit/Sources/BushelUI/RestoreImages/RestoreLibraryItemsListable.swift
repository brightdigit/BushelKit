//
// RestoreLibraryItemsListable.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelVirtualization
  import SwiftUI

  protocol RestoreLibraryItemsListable {
    var listItems: [RestoreImageLibraryItemFile] {
      get
    }

    func bindingFor(_ file: RestoreImageLibraryItemFile) -> Binding<RestoreImageLibraryItemFile>
  }
#endif
