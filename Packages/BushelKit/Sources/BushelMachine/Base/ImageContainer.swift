//
// ImageContainer.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

public protocol ImageContainer {
  var metadata: ImageMetadata { get }
  func installer() async throws -> ImageInstaller
}
