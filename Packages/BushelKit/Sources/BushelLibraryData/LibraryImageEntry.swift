//
// LibraryImageEntry.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(SwiftData)
  import BushelCore
  import BushelLibrary
  import BushelLogging
  import Foundation
  import SwiftData

  @Model
  public final class LibraryImageEntry {
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
    private var vmSystemID: String
    public var vmSystem: VMSystemID {
      get {
        .init(stringLiteral: vmSystemID)
      }
      set {
        self.vmSystemID = newValue.rawValue
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
      vmSystem: VMSystemID,
      fileExtension: String
    ) {
      self.name = name
      imageID = id
      self.isImageSupported = isImageSupported
      self.buildVersion = buildVersion
      self.operatingSystemVersionString = operatingSystemVersion.description
      self.contentLength = contentLength
      self.lastModified = lastModified
      self.vmSystemID = vmSystem.rawValue
      self.fileExtension = fileExtension
    }
  }

  extension LibraryImageEntry {
    convenience init(library: LibraryEntry, file: LibraryImageFile, using context: ModelContext) throws {
      self.init(
        name: file.name,
        id: file.id,
        isImageSupported: file.metadata.isImageSupported,
        buildVersion: file.metadata.buildVersion,
        operatingSystemVersion: file.metadata.operatingSystemVersion,
        contentLength: file.metadata.contentLength,
        lastModified: file.metadata.lastModified,
        vmSystem: file.metadata.vmSystem,
        fileExtension: file.metadata.fileExtension
      )
      context.insert(self)
      self.library = library
      try context.save()
    }

    func syncronizeFile(
      _ file: LibraryImageFile,
      withLibrary library: LibraryEntry,
      using context: ModelContext
    ) throws {
      name = file.name
      imageID = file.id
      isImageSupported = file.metadata.isImageSupported
      buildVersion = file.metadata.buildVersion
      operatingSystemVersion = file.metadata.operatingSystemVersion
      contentLength = file.metadata.contentLength
      lastModified = file.metadata.lastModified
      vmSystem = file.metadata.vmSystem
      fileExtension = file.metadata.fileExtension
      self.library = library
      try context.save()
    }
  }

  public extension ImageMetadata {
    init(entry: LibraryImageEntry) {
      self.init(
        isImageSupported: entry.isImageSupported,
        buildVersion: entry.buildVersion,
        operatingSystemVersion: entry.operatingSystemVersion,
        contentLength: entry.contentLength,
        lastModified: entry.lastModified,
        fileExtension: entry.fileExtension,
        vmSystem: entry.vmSystem
      )
    }
  }
#endif
