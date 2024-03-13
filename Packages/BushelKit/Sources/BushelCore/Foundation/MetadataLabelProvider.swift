//
// MetadataLabelProvider.swift
// Copyright (c) 2024 BrightDigit.
//

import Foundation

public typealias MetadataLabelProvider =
  @Sendable (VMSystemID, any OperatingSystemInstalled) -> MetadataLabel
