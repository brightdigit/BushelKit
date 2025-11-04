//
//  LibraryIdentifierTests.swift
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
import XCTest

@testable import BushelFoundation

internal final class LibraryIdentifierTests: XCTestCase {
  internal func testBookmarkIDFromString() {
    let expectedID = LibraryIdentifier.bookmarkID(.bookmarkIDSample)

    let sut = LibraryIdentifier(string: .libraryBookmarkIDSample)

    XCTAssertEqual(sut.description, expectedID.description)
  }

  internal func testURLFromString() {
    let homeDirectoryURL: URL

    if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
      homeDirectoryURL = URL.homeDirectory
    } else {
      homeDirectoryURL = URL(fileURLWithPath: NSHomeDirectory())
    }
    let fileURL = homeDirectoryURL.appendingPathComponent("file.txt")
    let url = LibraryIdentifier.url(fileURL)

    let sut = LibraryIdentifier(string: fileURL.path)

    XCTAssertEqual(sut.description, url.description)
  }
}
