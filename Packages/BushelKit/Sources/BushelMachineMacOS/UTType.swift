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

    static let iTunesIPSW: UTType = .init("com.apple.itunes.ipsw")!
    static let iPhoneIPSW: UTType = .init("com.apple.iphone.ipsw")!

    static let ipswTypes = [iTunesIPSW, iPhoneIPSW]
    static var restoreImageLibrary: UTType {
      UTType(exportedAs: "com.brightdigit.bushel-rilib")
    }
  }
#endif
