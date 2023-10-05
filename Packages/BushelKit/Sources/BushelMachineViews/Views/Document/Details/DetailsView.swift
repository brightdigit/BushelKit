//
// DetailsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelLocalization
  import SwiftUI

  struct DetailsView: View {
    var machineObject: MachineObject?
    var body: some View {
      HStack {
        Image(icon: Icons.Machine.desktop01).resizable().aspectRatio(contentMode: .fit).padding(80.0)
        GeometryReader { proxy in
          Group {
            if let machineObject {
              SpecificationsView(
                label: machineObject.label,
                configuration: machineObject.machine.configuration
              )
            }
          }
          .frame(
            minWidth: proxy.size.width / 2.0,
            minHeight: proxy.size.height,
            alignment: .center
          )
        }
      }
    }
  }
#endif
