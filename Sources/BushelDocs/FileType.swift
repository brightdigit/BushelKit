//
//  FileType.swift
//  BushelKit
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
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

internal import BushelFoundation
public import RadiantDocs

extension FileType {
  /// The file extension for an IPSW (iPhone Software Update) file.
  public static let ipswFileExtension = "ipsw"

  /// The file type for an iTunes IPSW file.
  public static let iTunesIPSW: FileType = "com.apple.itunes.ipsw"

  /// The file type for an iPhone IPSW file.
  public static let iPhoneIPSW: FileType = "com.apple.iphone.ipsw"

  /// The file extension for a virtual machine file.
  public static let virtualMachineFileExtension = FileNameExtensions.virtualMachineFileExtension

  /// The file extension for a restore image library file.
  public static let restoreImageLibraryFileExtension = FileNameExtensions
    .restoreImageLibraryFileExtension

  /// The file type for a virtual machine file.
  public static let virtualMachine: FileType = .exportedAs(
    "com.brightdigit.bushel-vm",
    virtualMachineFileExtension
  )

  /// The file type for a restore image library file.
  public static let restoreImageLibrary: FileType = .exportedAs(
    "com.brightdigit.bushel-rilib",
    restoreImageLibraryFileExtension
  )

  /// An array of all IPSW file types.
  public static let ipswTypes = [iTunesIPSW, iPhoneIPSW]
}
