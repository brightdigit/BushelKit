//
// Binding.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  extension Binding where Value == RestoreImageLibrary {
    func bindingFor(_ file: RestoreImageLibraryItemFile) -> Binding<RestoreImageLibraryItemFile> {
      guard let index = wrappedValue.items.firstIndex(of: file) else {
        preconditionFailure()
      }
      let library = self
      return library.items[index]
    }

    func optionalBindingFor(_ file: RestoreImageLibraryItemFile) -> Binding<RestoreImageLibraryItemFile>? {
      guard let index = wrappedValue.items.firstIndex(of: file) else {
        return nil
      }
      let library = self
      return library.items[index]
    }
  }
#endif
