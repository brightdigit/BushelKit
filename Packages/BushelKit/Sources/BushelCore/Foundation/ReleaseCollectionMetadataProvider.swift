//
// ReleaseCollectionMetadataProvider.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation
public typealias ReleaseCollectionMetadataProvider =
  @Sendable (VMSystemID) -> any ReleaseCollectionMetadata
