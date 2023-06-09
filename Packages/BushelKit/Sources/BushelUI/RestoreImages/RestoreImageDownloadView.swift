//
// RestoreImageDownloadView.swift
// Copyright (c) 2023 BrightDigit.
//

import BushelMachine
import SwiftUI

struct RestoreImageDownloadView: View {
  let url: URL
  @State var downloadDestination: RestoreImageDownloadDestination?
  @Binding var downloadRequest: RestoreImageDownloadRequest?
  let dismiss: () -> Void

  var body: some View {
    VStack {
      HStack {
        Button {
          Task { @MainActor in
            self.downloadDestination = .library
          }
        } label: {
          GroupBox {
            VStack {
              Image("UI/library", bundle: .module).resizable().aspectRatio(contentMode: .fit).padding(20.0)
              Text("Download and Use in a Library for a future Virtual Machine.").font(.subheadline)
            }.padding().frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
          }.overlay(
            RoundedRectangle(cornerRadius: 16).stroke(.blue, lineWidth: self.downloadDestination == .library ? 4 : 0)
          )
        }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
        Button {
          Task { @MainActor in
            self.downloadDestination = .ipswFile
          }
        } label: {
          GroupBox {
            VStack {
              Image(systemName: "square.and.arrow.down.fill").resizable().aspectRatio(contentMode: .fit).padding(20.0)
              Text("Download just to ipsw file for use outside of Bushel.").font(.subheadline)
            }.padding().frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
          }.overlay(
            RoundedRectangle(cornerRadius: 16).stroke(.blue, lineWidth: self.downloadDestination == .ipswFile ? 4 : 0)
          )
        }.frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
      }.buttonStyle(.plain).padding().frame(maxHeight: 400.0).aspectRatio(2, contentMode: .fit).layoutPriority(1.0)
      HStack {
        Spacer()
        Button(.cancel) {
          self.dismiss()
        }
        Button(.download) {
          guard let downloadDestination else {
            Self.logger.error("Invalid Saving Dialog. No Download Type Set.")
            return
          }

          self.downloadRequest = .init(sourceURL: url, destination: downloadDestination)
        }.disabled(self.downloadDestination == nil)
      }.padding(.horizontal)
    }.frame(minWidth: 0, maxWidth: .infinity).padding()
  }
}

struct RestoreImageDownloadView_Previews: PreviewProvider {
  static var previews: some View {
    RestoreImageDownloadView(url: .randomHTTP(), downloadRequest: .constant(nil)) {}
    RestoreImageDownloadView(url: .randomHTTP(), downloadDestination: .library, downloadRequest: .constant(nil)) {}
  }
}
