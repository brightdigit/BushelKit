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
      TabView {
        HStack {
          Image(icon: Icons.Machine.desktop01).resizable().aspectRatio(contentMode: .fit).padding(80.0)
          GeometryReader { proxy in
            Group {
              if let operatingSystem = document.machine.operatingSystem {
                MachineSpecListView(
                  specification: document.machine.specification,
                  operatingSystem: operatingSystem,
                  previewImageManager: nil
                )
              }
            }
            .frame(
              minWidth: proxy.size.width / 2.0,
              minHeight: proxy.size.height,
              alignment: .center
            )
          }
        }.tabItem {
          Label("System", image: "list.bullet.rectangle.fill")
        }
        SnapshotListView(document: self.$document, snapshots: document.machine.snapshots).tabItem {
          Label("Snapshots", image: "camera")
        }
      }.toolbar {
        ToolbarItemGroup {
          Button {
            do {
              try self.document.addSnapshot()
            } catch {
              Self.logger.error("couldn't take a snapshot: \(error.localizedDescription)")
            }
          } label: {
            Image(systemName: "camera")
            Text(.snapshotMachine)
          }
          Button {
            Windows.openWindow(withHandle: MachineSessionWindowHandle(machineFilePath: url.path))
          } label: {
            Image(systemName: "play")
            Text(.startMachine)
          }
        }
      }
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
