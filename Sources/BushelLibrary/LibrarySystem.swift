//
//  LibrarySystem.swift
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

public import BushelCore
public import Foundation
public import RadiantDocs

public protocol LibrarySystem: Sendable {
  var id: VMSystemID { get }
  var shortName: String { get }
  var allowedContentTypes: Set<FileType> { get }
  var releaseCollectionMetadata: any ReleaseCollectionMetadata { get }
  func metadata(fromURL url: URL) async throws -> ImageMetadata
  func label(fromMetadata metadata: any OperatingSystemInstalled) -> MetadataLabel
}

extension LibrarySystem {
  public func restoreImageLibraryItemFile(
    fromURL url: URL,
    id: UUID = UUID()
  ) async throws -> LibraryImageFile {
    let metadata = try await self.metadata(fromURL: url)
    let name = self.label(fromMetadata: metadata).defaultName
    return LibraryImageFile(id: id, metadata: metadata, name: name)
  }
}