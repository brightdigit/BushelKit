//
//  LibraryImageFile.swift
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

public import BushelLibrary
internal import Foundation

// swift-format-ignore: AlwaysUseLowerCamelCase
extension LibraryImageFile {
  public static let libraryImageSample: Self = .init(
    // swiftlint:disable:next force_unwrapping
    id: .init(uuidString: "C2D7C339-D60D-4E17-A665-3BFA53389DDD")!,
    metadata: .macOS_13_6_0_22G120,
    name: "macOS Ventura 13.6.0"
  )

  // swiftlint:disable:next identifier_name
  public static let monterey_12_6_0: Self = .init(
    // swiftlint:disable:next force_unwrapping
    id: .init(uuidString: "D8ED8AF1-9AC7-49D4-A29D-E81F67B5F489")!,
    metadata: .macOS_12_6_0_21G115,
    name: "macOS Monterey 12.6.0"
  )

  // swiftlint:disable:next identifier_name
  public static let ventura_13_6_0: Self = .init(
    // swiftlint:disable:next force_unwrapping
    id: .init(uuidString: "C2983C2F-D69A-47CD-8656-11314EAFE52F")!,
    metadata: .macOS_13_6_0_22G120,
    name: "macOS Ventura 13.6.0"
  )

  // swiftlint:disable:next identifier_name
  public static let sonoma_13_6_0: Self = .init(
    // swiftlint:disable:next force_unwrapping
    id: .init(uuidString: "9FD629E1-CC0C-444F-9836-513B5444EA44")!,
    metadata: .macOS_14_0_0_23A344,
    name: "macOS Sonoma 14.0.0"
  )
}
