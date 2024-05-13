//
//  FileType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2024 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

public struct FileType: Hashable, ExpressibleByStringLiteral, Sendable {
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

extension FileType {
  public static let ipswFileExtension = "ipsw"
  public static let iTunesIPSW: FileType = "com.apple.itunes.ipsw"
  public static let iPhoneIPSW: FileType = "com.apple.iphone.ipsw"

  public static let virtualMachineFileExtension = "bshvm"
  public static let restoreImageLibraryFileExtension = "bshrilib"

  public static let virtualMachine: FileType = .exportedAs(
    "com.brightdigit.bushel-vm",
    virtualMachineFileExtension
  )

  public static let restoreImageLibrary: FileType = .exportedAs(
    "com.brightdigit.bushel-rilib",
    restoreImageLibraryFileExtension
  )

  public static let ipswTypes = [iTunesIPSW, iPhoneIPSW]
}
