//
// RestoreLibraryItemsListable.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  protocol RestoreLibraryItemsListable {
    var listItems: [RestoreImageLibraryItemFile] {
      get
    }

    func bindingFor(_ file: RestoreImageLibraryItemFile) -> Binding<RestoreImageLibraryItemFile>
  }
#endif
