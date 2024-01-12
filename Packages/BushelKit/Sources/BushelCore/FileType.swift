//
// FileType.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public struct FileType: Hashable, ExpressibleByStringLiteral {
  public typealias StringLiteralType = String

  public let utIdentifier: String
  public let isOwned: Bool
  public let fileExtension: String?

  public init(
    utIdentifier: String,
    isOwned: Bool,
    fileExtension: String? = nil
  ) {
    self.utIdentifier = utIdentifier
    self.isOwned = isOwned
    self.fileExtension = fileExtension
  }

  public init(
    stringLiteral utIdentifier: String
  ) {
    self.init(
      utIdentifier: utIdentifier,
      isOwned: false
    )
  }

  public static func exportedAs(
    _ utIdentifier: String,
    _ fileExtension: String
  ) -> FileType {
    .init(
      utIdentifier: utIdentifier,
      isOwned: true,
      fileExtension: fileExtension
    )
  }
}

public extension FileType {
  static let iTunesIPSW: FileType = "com.apple.itunes.ipsw"
  static let iPhoneIPSW: FileType = "com.apple.iphone.ipsw"

  static let virtualMachine: FileType = .exportedAs("com.brightdigit.bushel-vm", "bshvm")

  // static let bshvm: UTType = .init(filenameExtension: "bshvm")!

  static var restoreImageLibrary: FileType = .exportedAs("com.brightdigit.bushel-rilib", "bshrilib")

  static let ipswTypes = [iTunesIPSW, iPhoneIPSW]
}
