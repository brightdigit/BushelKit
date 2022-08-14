//
// ImageMetadata.Previews.swift
// Copyright (c) 2022 BrightDigit.
// Created by Leo Dion on 8/12/22.
//

//
//  File.swift
//
//
//  Created by Leo Dion on 7/31/22.
//
import BushelMachine
import BushelMachineMacOS
import Foundation
import SwiftUI

public extension ImageMetadata {
  enum Previews {
    public static let previewModel: ImageMetadata = .init(isImageSupported: true, buildVersion: "12312SA", operatingSystemVersion: .init(majorVersion: 12, minorVersion: 0, patchVersion: 0), contentLength: 16_000_000_000, lastModified: .init(), fileExtension: "ipsw", vmSystem: .macOS)

    public static let venturaBeta3 = ImageMetadata(isImageSupported: true, buildVersion: "22A5295h", operatingSystemVersion: OperatingSystemVersion(majorVersion: 13, minorVersion: 0, patchVersion: 0), contentLength: 0, lastModified: Date(timeIntervalSinceReferenceDate: 679_094_144.0), fileExtension: "ipsw", vmSystem: .macOS)

    public static let monterey = ImageMetadata(isImageSupported: true, buildVersion: "21F79", operatingSystemVersion: OperatingSystemVersion(majorVersion: 12, minorVersion: 4, patchVersion: 0), contentLength: 0, lastModified: Date(timeIntervalSinceReferenceDate: 679_276_356.959953), fileExtension: "ipsw", vmSystem: .macOS)
  }
}

extension RestoreImageLibraryDocumentView_Previews {
  static let data: [RestoreImageLibraryItemFile] = [
    .init(id: .init(), name: "Ventura Beta 3", metadata: .Previews.venturaBeta3, fileAccessor: URLAccessor(url: URL(string: "file:///var/folders/5d/8rl1m9ts5r96dxdh4rp_zx100000gn/T/com.brightdigit.BshIll/B6844821-A5C8-42B5-80C2-20F815FB920E.ipsw")!)),
    .init(id: .init(), name: "Montery 12.4", metadata: .Previews.monterey, fileAccessor: URLAccessor(url: URL(string: "file:///var/folders/5d/8rl1m9ts5r96dxdh4rp_zx100000gn/T/com.brightdigit.BshIll/B6844821-A5C8-42B5-80C2-20F815FB920E.ipsw")!))
  ]
}
