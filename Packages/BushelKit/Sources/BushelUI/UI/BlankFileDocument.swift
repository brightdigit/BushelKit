//
// BlankFileDocument.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
//

import AppKit
import SwiftUI
import UniformTypeIdentifiers

protocol BlankFileDocument {
  static var allowedContentTypes: [UTType] { get }
  static func saveBlankDocumentAt(_ url: URL) throws
}
