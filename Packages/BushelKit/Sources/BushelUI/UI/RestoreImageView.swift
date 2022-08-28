//
// RestoreImageView.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

import BushelMachine
import SwiftUI
import UniformTypeIdentifiers

struct RestoreImageView: View {
  let byteFormatter: ByteCountFormatter = .init()
  let image: RestoreImagable
  @StateObject var downloader = Downloader()
  @State var downloadRequest: RestoreImageDownloadRequest?
  @State var sourceURL: URL?
  @State var restoreImageDownload: RestoreImageDownload?

  func beginDownloadRequest(_ downloadRequest: RestoreImageDownloadRequest) {
    let panel = NSSavePanel()
    switch downloadRequest.destination {
    case .ipswFile:
      panel.nameFieldLabel = "Save Restore Image as:"
      panel.nameFieldStringValue = image.metadata.defaultName
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

      switch downloadRequest.destination {
      case .ipswFile:
        self.beginDownload(from: downloadRequest.sourceURL, to: fileURL)
      case .library:
        do {
          try self.beginDownload(from: downloadRequest.sourceURL, toLibraryAt: fileURL)
        } catch {
          dump(error)
        }
      }
    }
  }

  func reset() {
    downloader.reset()
    sourceURL = nil
    downloadRequest = nil

    restoreImageDownload = nil
  }

  func beginDownload(from sourceURL: URL, toLibraryAt url: URL) throws {
    let fileID = UUID()
    let libraryDirectoryExists = FileManager.default.directoryExists(at: url)
    guard libraryDirectoryExists != .fileExists else {
      throw MissingError.needDefinition("Invalid Library")
    }

    let restoreImagesSubdirectoryURL = url.appendingPathComponent("Restore Images")
    let metadataURL = url.appendingPathComponent("metadata.json")

    if FileManager.default.fileExists(atPath: metadataURL.path), libraryDirectoryExists == .directoryExists {
      let restoreImageSubdirectoryExists = FileManager.default.directoryExists(at: restoreImagesSubdirectoryURL)

      guard restoreImageSubdirectoryExists != .fileExists else {
        throw MissingError.needDefinition("Invalid Library")
      }

      if restoreImageSubdirectoryExists == .notExists {
        try FileManager.default.createDirectory(at: restoreImagesSubdirectoryURL, withIntermediateDirectories: true)
      }
    } else {
      try RestoreImageLibraryDocument.saveBlankDocumentAt(url)
    }

    let destinationURL = restoreImagesSubdirectoryURL.appendingPathComponent(fileID.uuidString).appendingPathExtension(url.pathExtension)

    restoreImageDownload = .library(url, fileID)
    downloader.begin(from: sourceURL, to: destinationURL)
  }

  func beginDownload(from sourceURL: URL, to fileURL: URL) {
    restoreImageDownload = .file(fileURL)
    downloader.begin(from: sourceURL, to: fileURL)
  }

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
        case let .remote(url):

          if let prettyBytesTotal = downloader.prettyBytesTotal, let percentCompleted = downloader.percentCompleted {
            Button {
              downloader.cancel()
              downloader.reset()
              self.downloadRequest = nil
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
              self.sourceURL = url
            } label: {
              Image(systemName: "icloud.and.arrow.down")
              Text("Download Image (\(byteFormatter.string(fromByteCount: Int64(image.metadata.contentLength))))")
            }
          }
        case .file:

          Button {} label: {
            HStack {
              Image(systemName: "square.and.arrow.down.fill")
              Text("Import Image")
            }
          }
        }

      }.padding().sheet(item: self.$sourceURL) { url in

        Button("Save to an IPSW File") {
          self.downloadRequest = .init(sourceURL: url, destination: .ipswFile)
        }
        Button("Save to a Library") {
          self.downloadRequest = .init(sourceURL: url, destination: .library)
        }
      }
      .onChange(of: downloadRequest) { newValue in
        guard let downloadRequest = newValue else {
          return
        }
        self.beginDownloadRequest(downloadRequest)
        self.sourceURL = nil
      }.onReceive(self.downloader.$isCompleted, perform: { isCompletedResult in
        guard let isCompletedResult = isCompletedResult, let restoreImageDownload = self.restoreImageDownload else {
          return
        }
        self.reset()
        switch (isCompletedResult, restoreImageDownload) {
        case let (.failure(error), _):
          dump(error)
        case let (.success, .file(url)):
          NSWorkspace.shared.open(url.deletingLastPathComponent())
        case let (.success, .library(url, fileID)):
          let decoder = JSONDecoder()
          let encoder = JSONEncoder()
          let metadataJSON = url.appendingPathComponent("metadata.json")
          let fileURL = url.appendingPathComponent("Restore Images").appendingPathComponent(fileID.uuidString).appendingPathExtension("ipsw")
          let newFile = RestoreImageLibraryItemFile(id: fileID, metadata: self.image.metadata, fileAccessor: URLAccessor(url: fileURL))
          do {
            var library = try decoder.decode(RestoreImageLibrary.self, from: .init(contentsOf: metadataJSON))
            library.items.append(newFile)
            try encoder.encode(library).write(to: metadataJSON)
          } catch {
            dump(error)
          }
        }
      })

      .onAppear {
        #if DEBUG
          debugPrint(self.image.metadata)
        #endif
      }
    }
  }
}

struct RestoreImageView_Previews: PreviewProvider {
  static var previews: some View {
    RestoreImageView(image: RestoreImage.Previews.usingMetadata(.Previews.venturaBeta3))
  }
}
