//
// DebugDatabaseView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelData
  import BushelLocalization
  import SwiftData
  import SwiftUI

  extension LibraryImageEntry {
    var libraryBookmarkIDString: String {
      assert(self.library != nil)
      return self.library?.bookmarkDataID.uuidString ?? ""
    }
  }

  struct DebugDatabaseView: View {
    @Query var bookmarks: [BookmarkData]
    @Query var libraries: [LibraryEntry]
    @Query var images: [LibraryImageEntry]
    @Query var machines: [MachineEntry]
    @Query var snapshots: [SnapshotEntry]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
      VStack {
        Spacer()
        TabView {
          Table(self.bookmarks) {
            TableColumn("bookmarkID", value: \.bookmarkID.uuidString)
            TableColumn("path", value: \.path)
          }.padding().tabItem {
            Image(systemName: "bookmark.fill") // .resource("UI/library").resizable().aspectRatio(contentMode: .fit)
            Text("Bookmarks")
          }
          Table(self.libraries) {
            TableColumn("bookmarkID", value: \.bookmarkDataID.uuidString)
            TableColumn("images", value: \.imageCount.description)
          }.padding().tabItem {
            Image(systemName: "books.vertical.fill") // .resource("UI/library").resizable().aspectRatio(contentMode: .fit)
            Text("Libraries")
          }
          Table(self.images) {
            TableColumn("id", value: \.imageID.uuidString)
            TableColumn("libraryID", value: \.libraryBookmarkIDString)
            TableColumn("operatingSystem", value: \.operatingSystemVersion.description)
          }.padding().tabItem {
            Image(systemName: "photo.artframe") // .resource("UI/library").resizable().aspectRatio(contentMode: .fit)
            Text("Images")
          }
          Table(self.machines) {
            TableColumn("Name", value: \.name)
            TableColumn("Operating System", value: \.operatingSystemVersionDescription)
            TableColumn("Created At", value: \.createdAt.description)
            TableColumn("Last Opened", value: \.lastOpenedDescription)
          }.padding().tabItem {
            Image(systemName: "server.rack") // .resource("UI/library").resizable().aspectRatio(contentMode: .fit)
            Text("Machines")
          }
          Table(self.snapshots) {
            TableColumn("ID", value: \.snapshotID.description)
            TableColumn("Size", value: \.fileLength.description)
            TableColumn("Operating System", value: \.operatingSystemVersionDescription)
            TableColumn("Created At", value: \.createdAt.description)
          }.padding().tabItem {
            Image(systemName: "camera.badge.clock.fill") // .resource("UI/library").resizable().aspectRatio(contentMode: .fit)
            Text("Snapshots")
          }
        }
        Button("Done") {
          dismiss()
        }
      }.padding().frame(minWidth: 800, minHeight: 400)
    }
  }

  #Preview {
    DebugDatabaseView()
  }
#endif
