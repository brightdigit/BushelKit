//
// SnapshotListView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelMachine
  import BushelVirtualization
  import SwiftUI

  struct SnapshotListView: View {
    static let snapshotDateFormatter = {
      var formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .medium
      return formatter
    }()

    @State var shouldConfirmRestoringSnapshot = false
    @State var restoringSnapshot: MachineSnapshot?
    @Binding var document: MachineDocument
    @Environment(\.dismiss) var dismiss: DismissAction
    @State private var sortOrder = [
      KeyPathComparator(\MachineSnapshot.date, order: .reverse)
    ]
    @State private var selectedSnapshot: MachineSnapshot.ID?

    let snapshots: [MachineSnapshot]
    var body: some View {
      VStack {
        HStack(spacing: 4.0) {
          Button {} label: {
            Image(systemName: "square.and.arrow.up.fill")
          }
          Button {} label: {
            Image(systemName: "arrow.uturn.backward")
          }

          Button {} label: {
            Image(systemName: "trash.fill")
          }
          Spacer()
        }.padding(.vertical, 8.0)
        Table(snapshots, selection: self.$selectedSnapshot, sortOrder: self.$sortOrder) {
          TableColumn("") { snapshot in
            HStack {
              Button {} label: {
                Image(systemName: "square.and.arrow.up.fill")
              }
              Button {
                #warning("Swap for MainActor")
                DispatchQueue.main.async {
                  self.restoringSnapshot = snapshot
                  self.shouldConfirmRestoringSnapshot = true
                }
              } label: {
                Image(systemName: "arrow.uturn.backward")
              }

              Button {} label: {
                Image(systemName: "trash.fill")
              }
            }
          }

          TableColumn("Date", value: \.date) { snapshot in
            Text(snapshot.date, formatter: Self.snapshotDateFormatter)
          }
          TableColumn("Notes", value: \.notes).width(ideal: 160, max: 280)
        }
      }.toolbar {
        ToolbarItemGroup {
          Button {} label: {
            Image(systemName: "square.and.arrow.up.fill")
          }
          Button {} label: {
            Image(systemName: "arrow.uturn.backward")
          }

          Button {} label: {
            Image(systemName: "trash.fill")
          }
        }
      }.confirmationDialog("Restoring Snapshot",
                           isPresented: self.$shouldConfirmRestoringSnapshot,
                           presenting: self.restoringSnapshot) { snapshot in
        Button("Yes, take a snapshot now; then restore.", role: .none) {
          do {
            try self.document.addSnapshot()
          } catch {
            Self.logger.error("failure taking the snapshot: \(error.localizedDescription)")
            return
          }
          self.beginRestoringSnapshot(snapshot)
        }
        Button("No, it's okay if I loose the current state.", role: .destructive) {
          self.beginRestoringSnapshot(snapshot)
        }
        Button("Cancel", role: .cancel) {
          #warning("Swap for MainActor")
          DispatchQueue.main.async {
            self.restoringSnapshot = nil
          }
        }
      } message: { snapshot in
        VStack {
          Text("""
                      You want to restore the snapshot from \(snapshot.date).
                      Would like to take a shapshot now before restoring?
          """)
        }
      }
    }

    func getMachineURL() throws -> URL {
      guard let machineURL = try document.machine.getURL() else {
        throw DocumentError.undefinedType("Missing URL for machine", document.machine)
      }
      return machineURL
    }

    func beginRestoringSnapshot(_ snapshot: MachineSnapshot) {
      let machinePath: String
      let snapshotID = snapshot.id
      do {
        machinePath = try getMachineURL().path
      } catch {
        Self.logger.error("Unable to get machine's URL: \(error.localizedDescription)")
        return
      }
      let snapshotPath = SnapshotPath(machinePath: machinePath, snapshotID: snapshotID)
      Windows.openWindow(
        withHandle: SnapshotRestorationWindowHandle(snapshotPath: snapshotPath)
      )
      dismiss()
    }
  }

  struct SnapshotListView_Previews: PreviewProvider {
    static var previews: some View {
      SnapshotListView(
        document: .constant(
          MachineDocument(machine: .init(specification: .init(
            cpuCount: 2,
            memorySize: 1_000_000,
            storageDevices: [.init(id: .init(), label: "macOS System", size: 1_000_000)],
            networkConfigurations: [.init(attachment: .nat)],
            graphicsConfigurations: [
              .init(displays: [.init(widthInPixels: 1920, heightInPixels: 1080, pixelsPerInch: 80)])
            ]
          )))
        ),
        snapshots: [
          .preview(timeIntervalSinceNow: 60 * 60 * -1.0),
          .preview(timeIntervalSinceNow: 60 * 60 * -2.0),
          .preview(timeIntervalSinceNow: 60 * 60 * -3.0),
          .preview(timeIntervalSinceNow: 60 * 60 * -4.0)
        ]
      )
    }
  }
#endif
