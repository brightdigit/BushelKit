//
// InstallImage.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation

public protocol InstallImage {
  var url: URL { get }
  var metadata: ImageMetadata { get }
}
