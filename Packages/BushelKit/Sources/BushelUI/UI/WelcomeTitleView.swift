//
// WelcomeTitleView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/13/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct WelcomeTitleView: View {
  @State var openDocumentIsVisible = false
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Spacer()
        Image("Logo").resizable().aspectRatio(contentMode: .fit).frame(width: 150)
        Text("Welcome to Bushel").font(.custom("Raleway", size: 42.0)).fontWeight(.medium)
        Text("Version \(Configuration.applicationMarketingVersionText) (\(Configuration.applicationBuildFormatted))").font(.custom("Raleway", size: 14.0)).fontWeight(.medium).foregroundColor(.secondary)

        Spacer(minLength: 20.0)
        VStack(alignment: .leading) {
          WelcomeActionButton(imageSystemName: "plus.app", title: "Create a new Machine", description: "Create a new Virtual Machine for Testing Your App") {
            Windows.showNewDocumentWindow(ofType: .virtualMachine)
          }

          WelcomeActionButton(imageSystemName: "square.and.arrow.down", title: "Open an existing Machine", description: "Open and Run an existing virtual machine.") {
            self.openDocumentIsVisible = true
          }.fileImporter(isPresented: self.$openDocumentIsVisible, allowedContentTypes:
            [UTType(filenameExtension: "bshvm")!]) { result in
              if let url = try? result.get() {
                Windows.openDocumentAtURL(url)
              }
            }

          WelcomeActionButton(imageSystemName: "server.rack", title: "Start an Image Library", description: "Create a library for your Restore Images.") {
            Windows.showNewSavedDocumentWindow(ofType: RestoreImageLibraryDocument.self)
          }

          WelcomeActionButton(imageSystemName: "square.and.arrow.down.on.square", title: "Download a Restore Image", description: "Download a new version of macOS.") {
            Windows.openWindow(withHandle: BasicWindowOpenHandle.remoteSources)
          }
        }
        Spacer()
      }.padding()
      Spacer()
    }
  }
}

struct WelcomeTitleView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeTitleView()
  }
}
