//
// AdvancedSettingsView.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelData
  import SwiftData
  import SwiftUI

  struct AdvancedSettingsView: View {
    @State var error: Error?
    @State var presentDebugDatabaseView = false
    @Environment(\.modelContext) private var context

    var body: some View {
      Form {
        LabeledContent("Database:") {
          VStack {
            Button("Clear All Documents") {
              #warning("Add confirmation")
              do {
                try context.transaction {
                  try [any PersistentModel.Type].all.forEach {
                    try context.delete(model: $0)
                  }
                }
                try context.save()
              } catch {
                self.error = error
              }
            }
            Button("Debug View") {
              self.presentDebugDatabaseView = true
            }
          }
        }
      }.sheet(isPresented: self.$presentDebugDatabaseView, content: {
        DebugDatabaseView()
      })
    }
  }

  #Preview {
    TabView {
      AdvancedSettingsView().tabItem {
        Label("Advanced", systemImage: "star")
      }
    }.padding(20)
      .frame(width: 375, height: 150)
  }
#endif
