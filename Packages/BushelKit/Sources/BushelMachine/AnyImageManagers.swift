//
// AnyImageManagers.swift
// Copyright (c) 2022 BrightDigit.
//

//
// ImageManagers.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

#if canImport(os)
  import os
#else
  import Logging
#endif
#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers
#endif
public enum AnyImageManagers {
  private static var idMap = [VMSystemID: Int]()
  #if canImport(UniformTypeIdentifiers)
    private static var contentTypeMap = [UTType: Int]()

    public static func imageManager(
      forContentType contentType: UTType
    ) -> AnyImageManager? {
      contentTypeMap[contentType].flatMap { index in
        guard index < all.count, index >= 0 else {
          return nil
        }
        return all[index]
      }
    }
  #endif
  public private(set) static var all: [AnyImageManager] = []

  public static func imageManager(forSystem system: VMSystemID) -> AnyImageManager? {
    idMap[system].flatMap { index in
      guard index < all.count, index >= 0 else {
        return nil
      }
      return all[index]
    }
  }

  public static func load(_ imageManager: AnyImageManager) throws {
    let index = all.count
    let type = type(of: imageManager)
    all.append(imageManager)
    idMap[type.systemID] = index
    #if canImport(UniformTypeIdentifiers)
      let contentTypes = type.restoreImageContentTypes
      for contentType in contentTypes {
        contentTypeMap[contentType] = index
      }
    #endif
  }

  public static let logger = Logger.forCategory(.imageManagers)
}

public extension AnyImageManagers {
  static func load<ImageManagerType: ImageManager>(_ type: ImageManagerType.Type) throws {
    try load(type.init())
  }

  static func load(_ types: [AnyImageManager.Type]) throws {
    for type in types {
      try load(type.init())
    }
  }

  static func restoreImageFrom(
    accessor: FileAccessor,
    using loader: RestoreImageLoader
  ) async -> RestoreImage? {
    for manager in all {
      if let image = try? await manager.load(from: accessor, using: loader) {
        return image
      }
    }
    return nil
  }

  #if canImport(UniformTypeIdentifiers)
    static func imageManager(
      forURL url: URL
    ) -> AnyImageManager? {
      let typeIdentifier: String?
      do {
        typeIdentifier = try url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier
      } catch {
        logger.warning("error from url \(url): \(error.localizedDescription)")
        return nil
      }
      return typeIdentifier
        .flatMap(UTType.init)
        .flatMap(imageManager(forContentType:))
    }
  #endif
}