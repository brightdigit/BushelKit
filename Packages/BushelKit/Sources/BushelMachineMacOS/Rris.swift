//
// Rris.swift
// Copyright (c) 2023 BrightDigit.
//

#if canImport(Virtualization) && arch(arm64)
  import BushelMachine
  import Foundation
  import Virtualization

  public extension Rris {
    static let apple: Rris = .init(id: "apple", title: "Apple") {
      let vzRestoreImage = try await VZMacOSRestoreImage.fetchLatestSupported()
      let virRestoreImage = try await VirtualizationMacOSRestoreImage(
        vzRestoreImage: vzRestoreImage,
        fileAccessor: nil
      )
      return [RestoreImage(imageContainer: virRestoreImage)].compactMap { $0 }
    }
  }
#endif
