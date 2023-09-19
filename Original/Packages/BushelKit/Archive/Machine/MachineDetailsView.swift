//
// MachineDetailsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)

  import BushelMachine
  import BushelMachineMacOS
  import SwiftUI

  struct MachineDetailsView: View {
    @Binding var document: MachineDocument
    let url: URL

    var body: some View {
      
    }
  }

  struct MachineDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      MachineDetailsView(
        document: .constant(
          .init(machine:
            .preview
          )
        ), url: .init("http://google.com")
      ).previewLayout(.fixed(width: 640, height: 360))
    }
  }
#endif
