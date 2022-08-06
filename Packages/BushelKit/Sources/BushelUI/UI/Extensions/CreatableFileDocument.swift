//
// CreatableFileDocument.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/3/22.
//

import SwiftUI
import UniformTypeIdentifiers

protocol CreatableFileDocument: FileDocument {
  static var untitledDocumentType: UTType { get }
}
