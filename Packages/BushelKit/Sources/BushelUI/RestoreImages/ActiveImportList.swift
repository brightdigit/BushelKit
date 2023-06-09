//
// ActiveImportList.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import SwiftUI

  struct ActiveImportList: View {
    let activeImports: [ActiveRestoreImageImport]
    var body: some View {
      Section {
        ScrollView {
          ForEach(activeImports) { activeImport in
            HStack {
              ProgressView().scaleEffect(0.4)
              Text(activeImport.localizedImportingMessage)
            }.padding(-10.0)
          }.font(.caption)
        }
      }.frame(maxHeight: 100)
    }
  }
#endif
