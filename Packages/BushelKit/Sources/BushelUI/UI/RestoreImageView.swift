//
// RestoreImageView.swift
// Copyright (c) 2022 BrightDigit.
//

// swiftlint:disable file_length

#if canImport(SwiftUI) && canImport(UniformTypeIdentifiers)
  import BushelMachine
  import SwiftUI
  import UniformTypeIdentifiers

  // swiftlint:disable closure_body_length
  struct RestoreImageView: View {
    let byteFormatter: ByteCountFormatter = .init()
    let image: RestoreImagable
    @StateObject var downloader = Downloader()
    @State var downloadRequest: RestoreImageDownloadRequest?
    @State var sourceURL: URL?
    @State var restoreImageDownload: RestoreImageDownload?

    // swiftlint:disable:next function_body_length
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

    // swiftlint:disable:next function_body_length
    func beginDownload(from sourceURL: URL, toLibraryAt url: URL) throws {
      let fileID = UUID()
      let libraryDirectoryExists = FileManager.default.directoryExists(at: url)
      guard libraryDirectoryExists != .fileExists else {
        throw MissingError.needDefinition("Invalid Library")
      }

      let restoreImagesSubdirectoryURL = url.appendingPathComponent("Restore Images")
      let metadataURL = url.appendingPathComponent("metadata.json")

      let alreadyExists =
        FileManager.default.fileExists(atPath: metadataURL.path) &&
        libraryDirectoryExists == .directoryExists
      if alreadyExists {
        let restoreImageSubdirectoryExists = FileManager.default.directoryExists(
          at: restoreImagesSubdirectoryURL
        )

        guard restoreImageSubdirectoryExists != .fileExists else {
          throw MissingError.needDefinition("Invalid Library")
        }

        if restoreImageSubdirectoryExists == .notExists {
          try FileManager.default.createDirectory(
            at: restoreImagesSubdirectoryURL,
            withIntermediateDirectories: true
          )
        }
      } else {
        try RestoreImageLibraryDocument.saveBlankDocumentAt(url)
      }

      let destinationURL = restoreImagesSubdirectoryURL
        .appendingPathComponent(fileID.uuidString)
        .appendingPathExtension("ipsw")

      restoreImageDownload = .library(url, fileID)
      downloader.begin(from: sourceURL, to: destinationURL)
    }

    func beginDownload(from sourceURL: URL, to fileURL: URL) {
      restoreImageDownload = .file(fileURL)
      downloader.begin(from: sourceURL, to: fileURL)
    }

    var body: some View {
      VStack {
        Image(
          operatingSystemVersion: image.metadata.operatingSystemVersion
        )
        .resizable()
        .aspectRatio(1.0, contentMode: .fit)
        .frame(height: 80.0)
        .mask {
          Circle()
        }
        .overlay {
          Circle().stroke()
        }

        Text(
          // swiftlint:disable:next line_length
          "macOS \(OperatingSystemCodeName(operatingSystemVersion: image.metadata.operatingSystemVersion)?.name ?? "")"
        ).font(.title)
        Text(image.metadata.localizedVersionString)

        VStack(alignment: .leading) {
          switch self.image.location {
          case let .remote(url):

            if
              let localizedProgress = downloader.localizedProgress,
              let percentCompleted = downloader.percentCompleted {
              Button {
                downloader.cancel()
                downloader.reset()
                self.downloadRequest = nil
              } label: {
                Text(.cancel)
              }
              ProgressView(
                value: percentCompleted
              ) {
                Text(.downloading).font(.caption)
              }
              currentValueLabel: {
                Text(localizedProgress)
              }
            } else {
              Button {
                self.sourceURL = url
              } label: {
                Image(systemName: "icloud.and.arrow.down")
                Text(
                  .key(.downloadImage),
                  .text(
                    "(\(byteFormatter.string(fromByteCount: Int64(image.metadata.contentLength))))"
                  )
                )
              }
            }

          case .file:

            Button {} label: {
              HStack {
                Image(systemName: "square.and.arrow.down.fill")
                Text(.importImage)
              }
            }
          }
        }
        .padding()
        .sheet(item: self.$sourceURL) { url in
          Button(.saveToIpsw) {
            self.downloadRequest = .init(sourceURL: url, destination: .ipswFile)
          }
          Button(.saveToLibrary) {
            self.downloadRequest = .init(sourceURL: url, destination: .library)
          }
        }
        .onChange(of: downloadRequest) { newValue in
          guard let downloadRequest = newValue else {
            return
          }
          self.beginDownloadRequest(downloadRequest)
          self.sourceURL = nil
        }
        .onReceive(
          self.downloader.$isCompleted) { isCompletedResult in
            guard
              let isCompletedResult = isCompletedResult,
              let restoreImageDownload = self.restoreImageDownload else {
              return
            }
            self.reset()
            switch (isCompletedResult, restoreImageDownload) {
            case let (.failure(error), _):
              dump(error)

            case let (.success, .file(url)):
              NSWorkspace.shared.open(url.deletingLastPathComponent())

            case let (.success, .library(url, fileID)):

              let metadataJSON = url.appendingPathComponent("metadata.json")
              let fileURL = url
                .appendingPathComponent("Restore Images")
                .appendingPathComponent(fileID.uuidString)
                .appendingPathExtension("ipsw")
              let newFile = RestoreImageLibraryItemFile(
                id: fileID,
                metadata: self.image.metadata,
                fileAccessor: URLAccessor(url: fileURL)
              )
              do {
                var library: RestoreImageLibrary = try Configuration.JSON.tryDecoding(
                  .init(contentsOf: metadataJSON)
                )
                library.items.append(newFile)
                try Configuration.JSON.encoder.encode(library).write(to: metadataJSON)
              } catch {
                dump(error)
              }
            }
        }
      }
    }
  }

  #if canImport(Virtualization) && arch(arm64)
    struct RestoreImageView_Previews: PreviewProvider {
      static var previews: some View {
        RestoreImageView(image: RestoreImage.Previews.usingMetadata(.Previews.venturaBeta3))
      }
    }
  #endif
#endif
