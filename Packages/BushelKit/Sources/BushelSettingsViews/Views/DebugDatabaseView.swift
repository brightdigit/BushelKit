//
// DebugDatabaseView.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelData
  import BushelLocalization
  import SwiftData
  import SwiftUI

  struct DebugDatabaseView: View {
    @Query var bookmarks: [BookmarkData]
    @Query var libraries: [LibraryEntry]
    @Query(filter: #Predicate<LibraryImageEntry> {
      $0.library != nil
    }) var images: [LibraryImageEntry]
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
            Image(systemName: "bookmark.fill")
            Text(.databaseBookmarks)
          }
          Table(self.libraries) {
            TableColumn("bookmarkID", value: \.bookmarkDataID.uuidString)
            TableColumn("images", value: \.imageCount.description)
          }.padding().tabItem {
            Image(systemName: "books.vertical.fill")
            Text(.databaseLibraries)
          }
          Table(self.images) {
            TableColumn("id", value: \.imageID.uuidString)
            TableColumn("libraryID", value: \.libraryBookmarkIDString)
            TableColumn("operatingSystem", value: \.operatingSystemVersion.description)
          }.padding().tabItem {
            Image(systemName: "photo.artframe")
            Text(.databaseImages)
          }
          Table(self.machines) {
            TableColumn("Name", value: \.name)
            TableColumn("Operating System", value: \.operatingSystemVersionDescription)
            TableColumn("Created At", value: \.createdAt.description)
            TableColumn("Last Opened", value: \.lastOpenedDescription)
          }.padding().tabItem {
            Image(systemName: "server.rack")
            Text(.databaseMachines)
          }
          Table(self.snapshots) {
            TableColumn("ID", value: \.snapshotID.description)
            TableColumn("Operating System", value: \.operatingSystemVersionDescription)
            TableColumn("Created At", value: \.createdAt.description)
          }.padding().tabItem {
            Image(systemName: "camera.badge.clock.fill")
            Text(.databaseSnapshots)
          }
        }
        Button("Done") {
          dismiss()
        }
      }
      .padding()
      .frame(minWidth: 800, minHeight: 400)
    }
  }

  #Preview {
    DebugDatabaseView()
  }
#endif
