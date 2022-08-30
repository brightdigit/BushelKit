//
// ImageContainer.swift
// Copyright (c) 2022 BrightDigit.
//

import Foundation
public protocol ImageContainer {
  var metadata: ImageMetadata { get }
  var location: ImageLocation { get }
}
