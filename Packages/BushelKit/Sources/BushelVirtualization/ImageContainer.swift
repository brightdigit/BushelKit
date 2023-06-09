//
// ImageContainer.swift
// Copyright (c) 2023 BrightDigit.
//

import Foundation
public protocol ImageContainer {
  var metadata: ImageMetadata { get }
  var location: ImageLocation? { get }
}
