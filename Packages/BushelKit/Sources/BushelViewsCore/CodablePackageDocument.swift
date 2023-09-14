//
// CodablePackageDocument.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftUI)
  import BushelCore
  import BushelUT
  import Foundation
  import SwiftUI

  import UniformTypeIdentifiers
  public struct CodablePackageDocument<T: CodablePackage>: FileDocument {
    enum ReadError: Error {
      case missingConfigurationAtKey(String)
    }

    public static var readableContentTypes: [UTType] {
      T.readableContentTypes.map(UTType.init)
    }

    let configuration: T

    public init(configuration: T) {
      self.configuration = configuration
    }

    public init(configuration: ReadConfiguration) throws {
      let regularFileContents = configuration
        .file
        .fileWrappers?[T.configurationFileWrapperKey]?
        .regularFileContents
      guard let configJSONWrapperData = regularFileContents else {
        throw ReadError.missingConfigurationAtKey(T.configurationFileWrapperKey)
      }

      let configuration = try T.decoder.decode(T.self, from: configJSONWrapperData)
      self.init(configuration: configuration)
    }

    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
      let rootFileWrapper = configuration.existingFile ?? FileWrapper(directoryWithFileWrappers: [:])

      if let oldConfigJSONWrapper = rootFileWrapper.fileWrappers?[T.configurationFileWrapperKey] {
        rootFileWrapper.removeFileWrapper(oldConfigJSONWrapper)
      }

      let newConfigJSONData = try T.encoder.encode(self.configuration)
      let newConfigJSONWrapper = FileWrapper(regularFileWithContents: newConfigJSONData)
      newConfigJSONWrapper.preferredFilename = T.configurationFileWrapperKey
      rootFileWrapper.addFileWrapper(newConfigJSONWrapper)

      return rootFileWrapper
    }
  }

  public extension CodablePackageDocument where T: InitializablePackage {
    init() {
      self.init(configuration: .init())
    }
  }
#endif
