//
// RestoreImageView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine
import SwiftUI
import UniformTypeIdentifiers

struct RestoreImageView: View {
  let byteFormatter: ByteCountFormatter = .init()
  let image: RestoreImage
  @StateObject var downloader = Downloader()
  @State var downloadDestination: RestoreImageDownloadDestination?
  @State var askAboutDownload = false
  var body: some View {
    VStack {
      Image(operatingSystemVersion: image.metadata.operatingSystemVersion).resizable().aspectRatio(1.0, contentMode: .fit).frame(height: 80.0).mask {
        Circle()
      }.overlay {
        Circle().stroke()
      }

      Text("macOS \(OperatingSystemCodeName(operatingSystemVersion: image.metadata.operatingSystemVersion)?.name ?? "")").font(.title)
      Text("Version \(image.metadata.operatingSystemVersion.description) (\(image.metadata.buildVersion.description))")

      VStack(alignment: .leading) {
        switch self.image.location {
        case .remote:

          if let prettyBytesTotal = downloader.prettyBytesTotal, let percentCompleted = downloader.percentCompleted {
            Button {
              downloader.cancel()
              downloader.reset()
              self.downloadDestination = nil
            } label: {
              Text("Cancel")
            }
            ProgressView(value: percentCompleted) {
              Text("Downloading").font(.caption)
            } currentValueLabel: {
              Text("\(downloader.prettyBytesWritten) / \(prettyBytesTotal)")
            }
          } else {
            Button {
              self.askAboutDownload = true
            } label: {
              Image(systemName: "icloud.and.arrow.down")
              Text("Download Image (\(byteFormatter.string(fromByteCount: Int64(image.metadata.contentLength))))")
            }
          }
        case .local:

          Button {} label: {
            HStack {
              Image(systemName: "square.and.arrow.down.fill")
              Text("Import Image")
            }
          }
        case .library, .reloaded:
          Button {} label: {
            Image(systemName: "hammer.fill")
            Text("Build Machine")
          }
        }
      }

    }.padding().alert("Download Restore Image", isPresented: self.$askAboutDownload, actions: {
      Button("Save to an IPSW File") {
        self.downloadDestination = .ipswFile
      }
      Button("Save to a Library") {
        self.downloadDestination = .library
      }
    }, message: {
      Text("Would you to download this into library or just save the file?")
    }).onChange(of: downloadDestination) { newValue in
      guard let downloadDestination = newValue else {
        return
      }

      let panel = NSSavePanel()
      switch downloadDestination {
      case .ipswFile:
        panel.nameFieldLabel = "Save Restore Image as:"
        panel.nameFieldStringValue = image.metadata.url.lastPathComponent
        panel.allowedContentTypes = UTType.ipswTypes
        panel.isExtensionHidden = true
      case .library:
        panel.nameFieldLabel = "Save to Library:"
        panel.allowedContentTypes = [UTType.restoreImageLibrary]
        panel.isExtensionHidden = true
      }
      panel.begin { response in

        guard let fileURL = panel.url, response == .OK else {
          return
        }

        let destinationURL: URL
        do {
          destinationURL = try downloadDestination.destinationURL(fromSavePanelURL: fileURL)
        } catch {
          #warning("Something")
          return
        }
        downloader.begin(from: image.metadata.url, to: destinationURL)
      }
    }.onAppear {
      #if DEBUG
        debugPrint(self.image.metadata)
      #endif
    }
  }
}

struct RestoreImageView_Previews: PreviewProvider {
  static var previews: some View {
    // ImageMetadata(isImageSupported: true, buildVersion: "true", operatingSystemVersion: OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0, sha256: SHA256(base64Encoded: "LbNHYPVKVKpwXUmqZInQ1Nr9gaYni4IKjelvzpl72LI=")!, contentLength: 0, lastModified: 2022-07-09 21:15:44 +0000, url: file:///var/folders/5d/8rl1m9ts5r96dxdh4rp_zx100000gn/T/com.brightdigit.BshIll/B6844821-A5C8-42B5-80C2-20F815FB920E.ipsw
    RestoreImageView(image: .Previews.usingMetadata(.Previews.venturaBeta3))
  }
}
