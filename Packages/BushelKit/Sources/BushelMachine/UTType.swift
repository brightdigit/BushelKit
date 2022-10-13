//
// UTType.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers

  public extension UTType {
    static var virtualMachine: UTType {
      UTType(exportedAs: "com.brightdigit.bushel-vm")
    }

    // static let bshvm: UTType = .init(filenameExtension: "bshvm")!

    static var restoreImageLibrary: UTType {
      UTType(exportedAs: "com.brightdigit.bushel-rilib")
    }
  }
#endif
