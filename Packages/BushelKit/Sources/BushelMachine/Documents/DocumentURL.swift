//
// DocumentURL.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers
#endif

public struct DocumentURL {
  public enum DocumentType {
    case machine
    case library

    #if canImport(UniformTypeIdentifiers)
      init?(_ uttype: UTType) {
        switch uttype {
        case .virtualMachine:
          self = .machine

        case .restoreImageLibrary:
          self = .library

        default:
          return nil
        }
      }
    #endif
  }

  public let type: DocumentType
  public let url: URL

  #if canImport(UniformTypeIdentifiers)
    public init(url: URL) throws {
      guard let typeIdentifier = try url.resourceValues(forKeys: [.typeIdentifierKey]).typeIdentifier else {
        throw MachineError.undefinedType("an expceted url", url)
      }
      guard let uttype = UTType(typeIdentifier) else {
        throw MachineError.undefinedType("an expceted url and typeIdentifier", (url, typeIdentifier))
      }
      guard let type = DocumentType(uttype) else {
        throw MachineError.undefinedType("an expceted url and type", (url, uttype))
      }

      self.url = url
      self.type = type
    }
  #endif
}
