//
// ImageContainer.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/6/22.
//

public protocol ImageContainer {
  var metadata: ImageMetadata { get }
  var fileAccessor: FileAccessor? { get }
}
