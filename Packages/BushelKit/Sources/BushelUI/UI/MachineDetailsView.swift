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
    static let snapshotDateFormatter = {
      var formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .medium
      return formatter
    }()

    var body: some View {
      TabView {
        HStack {
          Image("Icons/Machines/001-desktop", bundle: Bundle.module).resizable().aspectRatio(contentMode: .fit).padding(50.0)

          GeometryReader { proxy in
            Group {
              if let operatingSystem = document.machine.operatingSystem {
                MachineSpecListView(specification: document.machine.specification, operatingSystem: operatingSystem, previewImageManager: nil)
              }
            }
            .frame(
              minWidth: proxy.size.width / 2.0,
              minHeight: proxy.size.height,
              alignment: .center
            )
          }
        }.padding().tabItem {
          Label("System", image: "list.bullet.rectangle.fill")
        }
        List {
          ForEach(document.machine.snapshots) { snapshot in
            HStack {
              Button {} label: {
                Image(systemName: "square.and.arrow.up.fill")
              }
              Button {} label: {
                Image(systemName: "arrow.uturn.backward")
              }

              Button {} label: {
                Image(systemName: "trash.fill")
              }
              Text(snapshot.date, formatter: Self.snapshotDateFormatter)
              Text(snapshot.date, style: .relative)
            }
          }
        }.tabItem {
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
            // Windows.openWindow(withHandle: MachineSessionWindowHandle(machineFilePath: url.path))
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
      ).previewLayout(.fixed(width: 500, height: 360))
    }
  }
#endif
