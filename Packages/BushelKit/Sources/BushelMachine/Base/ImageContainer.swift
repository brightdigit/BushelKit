//
// ImageContainer.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/21/22.
//

import Foundation
public protocol ImageContainer {
  var metadata: ImageMetadata { get }
  var location: ImageLocation { get }
}
