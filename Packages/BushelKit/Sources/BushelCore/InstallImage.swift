//
// InstallImage.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public protocol InstallImage {
  var url: URL { get }
  var metadata: ImageMetadata { get }
}
