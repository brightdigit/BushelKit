//
// Rris.Virtualization.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/2/22.
//

import BushelMachine
import Foundation
import Virtualization

public extension Rris {
  static let apple: Rris = .init(id: "apple", title: "Apple") {
    let vzRestoreImage = try await VZMacOSRestoreImage.fetchLatestSupported()
    let virRestoreImage = try await VirtualizationMacOSRestoreImage(vzRestoreImage: vzRestoreImage, sha256: nil)
    return [RestoreImage(imageContainer: virRestoreImage)]
  }
}
