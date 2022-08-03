//
// RestoreImageLibraryDocumentObject.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import SwiftUI

class RestoreImageLibraryDocumentObject: ObservableObject {
  internal init(document: Binding<RestoreImageLibraryDocument>) {
    _document = document
  }

  @Binding var document: RestoreImageLibraryDocument
}
