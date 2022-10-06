//
// UTType.swift
// Copyright (c) 2022 BrightDigit.
//

#if canImport(UniformTypeIdentifiers)
  import UniformTypeIdentifiers

  public extension UTType {
    // swiftlint:disable force_unwrapping
    static let iTunesIPSW: UTType = .init("com.apple.itunes.ipsw")!
    static let iPhoneIPSW: UTType = .init("com.apple.iphone.ipsw")!
    // swiftlint:enable force_unwrapping

    static let ipswTypes = [iTunesIPSW, iPhoneIPSW]
  }
#endif
