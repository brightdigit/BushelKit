//
// BlankFileDocument.swift
// Copyright (c) 2022 BrightDigit.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

protocol BlankFileDocument {
  static var allowedContentTypes: [UTType] { get }
  static func saveBlankDocumentAt(_ url: URL) throws
}
