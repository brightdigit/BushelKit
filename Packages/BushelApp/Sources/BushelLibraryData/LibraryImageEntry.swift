//
// LibraryImageEntry.swift
// Copyright (c) 2024 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelDataCore
  import BushelLibrary
  import BushelLogging
  import Foundation
  import SwiftData

  #warning("I think we need to log the operations running for this entry")
  @Model
  public final class LibraryImageEntry: Sendable {
    public var library: LibraryEntry?
    public var name: String
    @Attribute(.unique)
    public var imageID: UUID
    public var isImageSupported: Bool
    public var buildVersion: String?
    @Attribute(originalName: "operatingSystemVersion")
    private var operatingSystemVersionString: String
    public var operatingSystemVersion: OperatingSystemVersion {
      get {
        // swiftlint:disable:next force_try
        try! .init(string: operatingSystemVersionString)
      }
      set {
        self.operatingSystemVersionString = newValue.description
      }
    }

    public var contentLength: Int
    public var lastModified: Date
    private var vmSystemIDRawValue: String
    public var vmSystemID: VMSystemID {
      get {
        .init(stringLiteral: vmSystemIDRawValue)
      }
      set {
        self.vmSystemIDRawValue = newValue.rawValue
      }
    }

    public var fileExtension: String

    internal init(
      name: String,
      id: UUID,
      isImageSupported: Bool,
      buildVersion: String?,
      operatingSystemVersion: OperatingSystemVersion,
      contentLength: Int,
      lastModified: Date,
      vmSystemID: VMSystemID,
      fileExtension: String
    ) {
      self.name = name
      imageID = id
      self.isImageSupported = isImageSupported
      self.buildVersion = buildVersion
      self.operatingSystemVersionString = operatingSystemVersion.description
      self.contentLength = contentLength
      self.lastModified = lastModified
      self.vmSystemIDRawValue = vmSystemID.rawValue
      self.fileExtension = fileExtension
    }
  }

  extension LibraryImageEntry {
    internal convenience init(
      library: LibraryEntry,
      file: LibraryImageFile,
      using database: any Database
    ) async throws {
      self.init(
        name: file.name,
        id: file.id,
        isImageSupported: file.metadata.isImageSupported,
        buildVersion: file.metadata.buildVersion,
        operatingSystemVersion: file.metadata.operatingSystemVersion,
        contentLength: file.metadata.contentLength,
        lastModified: file.metadata.lastModified,
        vmSystemID: file.metadata.vmSystemID,
        fileExtension: file.metadata.fileExtension
      )
      await database.insert(self)
      try await database.save()
      self.library = library
      try await database.save()
    }

    internal func syncronizeFile(
      _ file: LibraryImageFile,
      withLibrary library: LibraryEntry,
      using database: any Database
    ) async throws {
      name = file.name
      imageID = file.id
      isImageSupported = file.metadata.isImageSupported
      buildVersion = file.metadata.buildVersion
      operatingSystemVersion = file.metadata.operatingSystemVersion
      contentLength = file.metadata.contentLength
      lastModified = file.metadata.lastModified
      vmSystemID = file.metadata.vmSystemID
      fileExtension = file.metadata.fileExtension
      self.library = library
      try await database.save()
    }
  }

  extension ImageMetadata {
    public init(entry: LibraryImageEntry) {
      self.init(
        isImageSupported: entry.isImageSupported,
        buildVersion: entry.buildVersion,
        operatingSystemVersion: entry.operatingSystemVersion,
        contentLength: entry.contentLength,
        lastModified: entry.lastModified,
        fileExtension: entry.fileExtension,
        vmSystemID: entry.vmSystemID
      )
    }
  }
#endif